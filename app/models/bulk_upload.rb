class BulkUpload < ActiveRecord::Base
  # to use text search
  include PgSearch
  belongs_to :user

  pg_search_scope :search,
                  :against => [:id ,:upload_date, :total_records, :success_count, :failure_count, :file_name],
                  :using => {:tsearch => {:dictionary => "english", :prefix => true}},
                  :associated_against => {user: [:id, :first_name, :last_name]}

  # save the data of bulk upload when data is uploaded to database
  def self.set_bulk_upload(total_records, time_taken, success_count, file_name,user_id)
    transaction do
      bulk_upload = BulkUpload.new
      bulk_upload.total_records = total_records
      bulk_upload.time_taken = time_taken
      bulk_upload.success_count = success_count
      bulk_upload.failure_count = total_records - success_count
      bulk_upload.file_name = file_name
      bulk_upload.upload_date = Date.today
      bulk_upload.user_id = user_id
      bulk_upload.save!
    end
  end

  # utility to create customer using the row read from the uploaded file
  def self.create_customer(attributes)
    puts "Attributes ::: #{attributes}"
    transaction do
      customer = User.new
      customer.first_name = attributes['First name']
      customer.last_name = attributes['Last name']
      customer.email = attributes['Email']
      customer.date_of_birth = attributes['Date of Birth']
      customer.phone_number = attributes['Phone Number']
      if attributes['Zip code'].is_a?Float
       attributes['Zip code'] = attributes['Zip code'].ceil
      end
      customer.password = attributes['Password']
      credit_card = customer.credit_cards.new
      address = customer.build_address
      address.house_name = attributes['House name']
      address.street = attributes['Street']
      address.area = attributes['Area']
      geographic = Geographic.where(zip_code: attributes['Zip code'].to_s).empty? ? Geographic.new : Geographic.where(zip_code: attributes['Zip code'].to_s).first
      if geographic.id.nil?
        geographic.zip_code = attributes['Zip code'].to_s
        geographic.country = attributes['Country']
        geographic.state = attributes['State']
        geographic.city = attributes['City']
        geographic.save!
        address.geographic_id = geographic.id
      else
        address.geographic_id = geographic.id
      end
      credit_card.card_number = attributes['Card number']
      credit_card.valid_from_date = attributes['Valid From Date']
      credit_card.valid_to_date = attributes['Valid To Date']
      credit_card.cvv = attributes['CVV']
      credit_card.credit_limit = attributes['Credit limit']
      credit_card.reward_points = attributes['Reward points']
      credit_card.statement_date = attributes['Statement Date']
      credit_card.name_on_card = attributes['Name on card']
      customer.save!
      true
    end
  rescue
      # TODO to be logged into log file
      Rails.logger.error "Failed to save customer with this data #{attributes}"
      false
  end

  # utility to create transaction using the row read from the uploaded file
  def self.create_transaction(attributes)
    transaction do
      transaction = Transaction.new
      credit_card = CreditCard.where(:card_number => attributes['Credit Card Number']).first
      if !credit_card.nil?
        transaction.credit_card_id = credit_card.id
        transaction.user_id = credit_card.user_id
        transaction.amount = attributes['Amount'].to_f
        transaction.description = attributes['Description']
        transaction.transaction_date = attributes['Transaction Date']
        transaction.balance = credit_card.available_credit_limit - transaction.amount
        if transaction.save!
          available_credit_limit = credit_card.available_credit_limit - attributes['Amount'].to_f
          credit_card.update_attributes!(:available_credit_limit => available_credit_limit)
          true
        end
      else
       return "Credit card with #{attributes['Credit Card Number']} card number was not found in our records."
      end
    end
  rescue
      # TODO to be logged into log file
      Rails.logger.error "Error occurred while upload transaction with this #{attributes}"
      false
  end

  def self.text_search(query)
    if query.present?
      search(query)
    else
      default_scoped
    end
  end

  def uploaded_by
    User.find(self.user_id).display_name
  end

end

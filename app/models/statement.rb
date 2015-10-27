class Statement < ActiveRecord::Base
  include PgSearch

  # Associations
  belongs_to :user
  belongs_to :credit_card

  # Required field validations
  validates_presence_of :statement_date, :credit_card_id, :user_id, :amount_due, :from_date, :to_date
  validates_uniqueness_of :statement_date, :scope => :credit_card_id

  pg_search_scope :search, :against => [:id ,:statement_date, :from_date, :to_date, :amount_due],
                  :using => {:tsearch => {:dictionary => 'english', :prefix => true}},
                  :associated_against => {:user => [:first_name, :last_name, :email, :phone_number], :credit_card => [:card_number, :credit_limit, :available_credit_limit]}

  def document_url
    $BUCKET.object(self.file_path).presigned_url(:get)
  end

  def self.text_search(query)
    if query.present?
      search(query)
    else
      default_scoped
    end
  end

  def credit_card_number
    CreditCard.where(:id => self.credit_card_id).first.card_number
  end


end

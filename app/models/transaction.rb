class Transaction < ActiveRecord::Base
  include PgSearch

  # ActiveRecord Relationships
  belongs_to :user
  belongs_to :credit_card

  # Required field validations
  validates_presence_of :transaction_date, :amount, :balance

  pg_search_scope :search, :against => [:id , :amount, :balance, :description, :transaction_date],
                  :using => {:tsearch => {:dictionary => 'english', :prefix => true}},
                  :associated_against => {:user => [:first_name, :last_name, :email, :phone_number], :credit_card => [:card_number, :credit_limit, :available_credit_limit]}

  def self.text_search(query)
    if query.present?
      search(query)
    else
      default_scoped
    end
  end

  def credit_card_available_credit_limit
    CreditCard.where(:id => self.credit_card_id).first.available_credit_limit
  end

  def customer_name
    User.where(:id => self.user_id).first.display_name
  end
end

class CreditCard < ActiveRecord::Base

  # Associations
  belongs_to :user, :touch => true
  has_many :transactions, :dependent => :delete_all
  has_many :statements, :dependent => :delete_all

  before_create :set_available_credit_limit

  # Validations
  validates_presence_of :card_number, :credit_limit, :valid_from_date, :valid_to_date, :cvv
  validates_numericality_of :cvv
  validates_numericality_of :credit_limit, greater_than: 0
  validates_uniqueness_of :card_number

  # custom validations
  validate :validate_statement_date, :validate_from_date, :validate_to_date

  def validate_statement_date
    errors.add(:statement_date, 'cannot be in the past') if
        !statement_date.blank? and statement_date < Date.today
  end

  def validate_from_date
    errors.add(:valid_from_date, 'must be less than valid to date') if
        !valid_from_date.blank? and valid_from_date >= valid_to_date
  end

  def validate_to_date
    errors.add(:valid_to_date, 'must be greater than valid from date') if
        !valid_to_date.blank? and valid_to_date <= valid_from_date
  end

  def set_available_credit_limit
    self.available_credit_limit = self.credit_limit
  end

end

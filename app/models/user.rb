class User < ActiveRecord::Base
  # to use text search
  include PgSearch

  pg_search_scope :search,
                  :against => [:id ,:first_name, :last_name, :email, :phone_number, :date_of_birth],
                  :using => {:tsearch => {:dictionary => "english", :prefix => true}},
                  :associated_against => {credit_cards: [:card_number, :credit_limit, :available_credit_limit]}

  # Associations
  has_one :address, :dependent => :destroy
  has_many :credit_cards, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  has_many :statements, :dependent => :destroy
  has_many :bulk_uploads, :dependent => :destroy

  # Accept Nested Attributes for user
  accepts_nested_attributes_for :credit_cards, allow_destroy: true
  accepts_nested_attributes_for :address, allow_destroy: true

  # Authentication
  has_secure_password

  # Required fields validations
  validates_presence_of :first_name, :last_name, :email, :date_of_birth, :phone_number
  validates_uniqueness_of :email

  # custom validations
  validate :validate_date_of_birth

  def validate_date_of_birth
    errors.add(:date_of_birth, 'cannot be in the future') if
        !date_of_birth.blank? and date_of_birth > Date.today
  end

  # Callbacks
  after_initialize :add_role

  # set role as customer to user
  def add_role
    self.role = 'customer'
  end

  # get the full name of the user
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  # get the display name of user
  def display_name
    "#{self.last_name}, #{self.first_name}"
  end

  # get the profile pic url
  def profile_pic_url
    $BUCKET.object(self.profile_pic_path).presigned_url(:get)
  end

  def self.text_search(query)
    if query.present?
      search(query)
    else
      default_scoped
    end
  end

  # Get all customers
  def self.customers
    where(role: 'customer')
  end

end

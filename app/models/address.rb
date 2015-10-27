class Address < ActiveRecord::Base

  # Associations
  belongs_to :user, :touch => true

  # Required fields validations
  validates_presence_of :house_name, :street, :area, :geographic_id

end

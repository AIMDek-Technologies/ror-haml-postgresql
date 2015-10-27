class Geographic < ActiveRecord::Base

  # Required fields validations
  validates_presence_of :zip_code, :country, :state, :city
  validates_uniqueness_of :zip_code

end

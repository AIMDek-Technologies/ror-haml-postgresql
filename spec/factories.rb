FactoryGirl.define do
  factory :user do |f|
    f.sequence(:first_name) {|n| "first name#{n}"}
    f.sequence(:last_name) {|n| "last name#{n}"}
    f.sequence(:email) {|n| "example#{n}@test.com"}
    f.sequence(:password) {|n| "test#{n}"}
    f.sequence(:phone_number) {|n| "12345#{n}23#{n}#{n}"}
    f.date_of_birth '12-12-1980'
  end
end
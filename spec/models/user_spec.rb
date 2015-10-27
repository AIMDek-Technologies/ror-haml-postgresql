require 'spec_helper'
require 'rails_helper'
require 'user'


describe User do

  it 'is invalid without a first name' do
    subject.first_name = 'Adam'
    expect(subject.first_name).to_not be_nil
  end

  it 'is invalid without a last name' do
    subject.last_name = 'Levine'
    expect(subject.last_name).to_not be_nil
  end

  it 'is invalid without an email address' do
    subject.email = 'adam.levine@maroon5.com'
    expect(subject.email).to_not be_nil
  end

  it 'is invalid without a date of birth' do
    subject.date_of_birth = '12-12-1980'
    expect(subject.date_of_birth).to_not be_nil
  end

  it 'is invalid with a duplicate email address' do
  User.create!(
      first_name: 'Logan', last_name: 'Tester',
      email: 'tester@example.com', date_of_birth: '12-10-1960',
      password: 'test', phone_number: '1234567890'
   )
  user = User.new(
       first_name: 'Adam', last_name: 'Levine',
       email: 'tester@example.com', date_of_birth: '12-01-1980',
       password: 'test', phone_number: '1234567890'
  )
  expect { user.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'has valid a display name' do
    subject.first_name = 'Adam'
    subject.last_name = 'Levine'
    expect(subject.display_name).to eq('Levine, Adam')
  end

  it 'has valid a full name' do
    subject.first_name = 'Adam'
    subject.last_name = 'Levine'
    expect(subject.full_name).to eq('Adam Levine')
  end

  it 'has role a customer role' do
    subject.add_role
    expect(subject.role).to eq('customer')
  end

  it 'is invalid with future date as date of birth' do
    subject.date_of_birth = '02-01-1992'
    expect(subject.date_of_birth).to be < Date.today
  end

  describe '.text_search'  do
    context 'when query is present' do

    end

    context 'when query is not present' do
      it 'returns a default scoped users' do
        expect(User.default_scoped).to eq(User.all)
      end
    end
  end

end
require 'rails_helper'
require 'spec_helper'
require 'credit_card'

describe CreditCard do

  it 'is invalid without card number' do
    subject.card_number = '1234-1234-1234-1234'
    expect(subject.card_number).not_to be_nil
  end

  it 'is invalid without credit limit' do
    subject.credit_limit = 12345
    expect(subject.credit_limit).not_to be_nil
  end

  it 'is invalid without valid from date' do
    subject.valid_from_date = '12-12-2014'
    expect(subject.valid_from_date).not_to be_nil
  end

  it 'is invalid without valid to date' do
    subject.valid_to_date = '12-12-2016'
    expect(subject.valid_to_date).not_to be_nil
  end

  it 'is invalid without CVV' do
    subject.cvv = '123'
    expect(subject.cvv).not_to be_nil
  end

  it 'is invalid with past date as statement date' do
    subject.statement_date = Date.today + 1.day
    expect(subject.statement_date).to be > Date.today
  end

  it 'is invalid with duplicate card number' do
    CreditCard.create!(:card_number => '1234-1234-1234-1234', :credit_limit => 1000,
                       :cvv => 123, :valid_from_date => '12-12-2012', :valid_to_date => '12-12-2015')
    credit_card = CreditCard.new(:card_number => '1234-1234-1234-1234', :credit_limit => 1000,
                                 :cvv => 123, :valid_from_date => '12-12-2012', :valid_to_date => '12-12-2015')
    expect {credit_card.save!}.to raise_error {ActiveRecord::RecordInvalid}
  end

  it 'is invalid when valid from date is greater than valid to date' do
    credit_card = CreditCard.create(:card_number => '1234-1234-1234-1234', :credit_limit => 1000,
                                    :cvv => 123, :valid_from_date => '12-12-2014', :valid_to_date => '12-10-2014')
    expect {credit_card.save!}.to raise_error {ActiveRecord::RecordInvalid}
  end

end

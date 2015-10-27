require 'rails_helper'
require 'spec_helper'
require 'statement'

describe Statement do

  it 'is invalid without a statement date' do
    subject.statement_date = '12-12-2014'
    expect(subject.statement_date).not_to be_nil
  end

  it 'is invalid without a credit card' do
    subject.credit_card_id = 1
    expect(subject.credit_card_id).not_to be_nil
  end

  it 'is invalid without user' do
    subject.user_id = 1
    expect(subject.user_id).not_to be_nil
  end

  it 'is invalid without from date' do
    subject.from_date = '12-12-2014'
    expect(subject.from_date).not_to be_nil
  end

  it 'is invalid without to date' do
    subject.to_date = '12-12-2014'
    expect(subject.to_date).not_to be_nil
  end

  it 'is invalid with same statement date and same credit card' do
    Statement.create!(:statement_date => '12-12-2014', :credit_card_id => 2,
                      :from_date => '12-12-2012', :to_date => '12-12-2015', :user_id => 1, :amount_due => 20)

    statement = Statement.new(:statement_date => '12-12-2014', :credit_card_id => 2,
                              :from_date => '12-12-2012', :to_date => '12-12-2015', :user_id => 1, :amount_due => 12)
    expect {statement.save!}.to raise_error ActiveRecord::RecordInvalid
  end

end
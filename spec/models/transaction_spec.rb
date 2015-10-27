require 'rails_helper'
require 'spec_helper'
require 'transaction'

describe Transaction, type: :model do

  it 'is invalid without a transaction date' do
    subject.transaction_date = '12-12-2014'
    expect(subject.transaction_date).not_to be_nil
  end
  it 'is invalid without a transaction id' do
    subject.transaction_id = 'T-1'
    expect(subject.transaction_id).not_to be_nil
  end
  it 'is invalid without a credit card' do
    subject.credit_card_id = 1
    expect(subject.credit_card_id).not_to be_nil
  end
  it 'is invalid without a user' do
    subject.user_id = 1
    expect(subject.user_id).not_to be_nil
  end
  it 'is invalid without an amount' do
    subject.amount = 10
    expect(subject.amount).not_to be_nil
  end

end

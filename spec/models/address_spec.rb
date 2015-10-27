require 'rails_helper'
require 'spec_helper'
require 'address'

describe Address do

  it 'is invalid without house name' do
    subject.house_name = 'Test House'
    expect(subject.house_name).not_to be_nil
  end

  it 'is invalid without street' do
    subject.street = 'Test Street'
    expect(subject.street).not_to be_nil
  end

  it 'is invalid without area' do
    subject.area = 'Test Area'
    expect(subject.area).not_to be_nil
  end

  it 'is invalid without user' do
    subject.user_id = 1
    expect(subject.user_id).not_to be_nil
  end

  it 'is invalid without geographic' do
    subject.geographic_id = 1
    expect(subject.geographic_id).not_to be_nil
  end

end

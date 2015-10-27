require 'rails_helper'
require 'spec_helper'
require 'geographic'

describe Geographic do

  it 'is invalid without zip code' do
    subject.zip_code = '12345'
    expect(subject.zip_code).not_to be_nil
  end

  it 'is invalid without country' do
    subject.country = 'Test Country'
    expect(subject.country).not_to be_nil
  end

  it 'is invalid without state' do
    subject.state = 'Test State'
    expect(subject.state).not_to be_nil
  end

  it 'is invalid without city' do
    subject.city = 'Test city'
    expect(subject.city).not_to be_nil
  end

  it 'is invalid with duplicate zip code' do
    Geographic.create!(:zip_code => '12345', :country => 'Test Country', :state => 'Test State', :city => 'Test City')
    geographic = Geographic.new(:zip_code => '12345', :country => 'Test Country', :state => 'Test State', :city => 'Test City')
    expect {geographic.save!}.to raise_error ActiveRecord::RecordInvalid
  end

end

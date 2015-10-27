require 'rails_helper'
require 'spec_helper'
require 'bulk_upload'

describe BulkUpload do

  it 'is invalid without upload date' do
    subject.upload_date = Date.today
    expect(subject.upload_date).not_to be_nil
  end

  it 'is invalid without having records' do
    subject.total_records = 100
    expect(subject.total_records).to be > 0
  end

  it 'is invalid without uploader' do
    subject.user = create(:user)
    expect(subject.user).not_to be_nil
  end

  it 'must be uploaded by admin user' do
    user = create(:user)
    user.role = 'admin'
    subject.user = user
    expect(subject.user.role).to eq('admin')
  end

end

require 'rails_helper'
require 'bulk_upload'
require 'capybara'

RSpec.describe 'BulkUploads', type: :request do
  describe 'manage bulk uploads' do
    context 'when user upload document' do
      it 'upload customers and display the upload details' do
        visit new_bulk_upload_path
        expect(response.body).to include("Upload")
      end

      it 'upload transactions and display the upload details'
    end
  end
end

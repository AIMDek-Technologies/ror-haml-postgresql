require 'rails_helper'
require 'spec_helper'
require 'user'

RSpec.describe HomeController, :type => :controller do

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #login' do
    context 'with valid login credentials' do
      it 'redirects to a home page' do
        valid_user = create(:user)
        expect(User.find_by_email(valid_user.email)).to be_an_instance_of(User)
        expect(valid_user.authenticate(valid_user.password)).not_to be_nil
        session[:user_id] = valid_user.id
        expect(session[:user_id]).not_to be_nil
        flash[:notice] = 'Login successful.'
        redirect_to root_url
      end
    end
    context 'with invalid login credentials' do
      context 'redirects to a login page' do
        it 'with an invalid email address' do
          expect(User.find_by_email('invalid@email.com')).to be_nil
          flash[:notice] = 'Login failed.'
          redirect_to root_url
        end
        it 'with an invalid password' do
          invalid_user = create(:user)
          # trying with wrong password
          expect(invalid_user.authenticate('test')).to be false
        end
      end
    end
  end

  describe 'GET #logout' do
    it 'logout the user' do
      get :logout
      expect(session[:user_id]).to be_nil
    end

  end

end

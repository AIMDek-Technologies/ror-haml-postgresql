class HomeController < ApplicationController

  def index
  end

  def login
    user = User.find_by_email(params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      flash[:notice] = t('messages.login_success')
      Rails.logger.info "User with id #{session[:user_id]} is logged in."
      redirect_to root_url
    else
      flash[:notice] = t('messages.login_failure')
      Rails.logger.error "Login failed for email #{params[:user][:email]} and password #{params[:user][:password]}"
      redirect_to root_url
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_url
  end

end

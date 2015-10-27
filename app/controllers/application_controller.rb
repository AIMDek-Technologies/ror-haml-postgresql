class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # default pagination per page
  WillPaginate.per_page = 10

  def login_required
    redirect_to root_path if session[:user_id].nil?
  end

end

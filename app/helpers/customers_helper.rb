module CustomersHelper

  def customers(page)
    User.where(:role => 'customer').page(page.to_i)
  end

  def current_user
    User.find(session[:user_id])
  end

end

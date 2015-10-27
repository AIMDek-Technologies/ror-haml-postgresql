class MigrationController < ApplicationController


  def generate_customer_id
    users = User.where(:role => 'customer')
    users.each.with_index do |user,index|
      customer_id = "C-#{index}"
      user.update_attributes(:customer_id => customer_id)
      user.save
    end
    render :text => 'Customer ID generated successfully'
  end

end

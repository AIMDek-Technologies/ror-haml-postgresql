class CustomerMailer < ActionMailer::Base
  default from: "notify@aimdek.com"

  def account_creation_notification(user, password)
    @user = user
    @password = password
    mail(:to => user.email, :subject => "Notification - Your account has been created.").deliver!
  end

end

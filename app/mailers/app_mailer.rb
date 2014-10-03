class AppMailer < ActionMailer::Base


  def send_forgot_password(user)
    @user = user
    address = (ENV["REAL_PRODUCTION"] == 'real_production')  ? @user.email  : 'rick.heller@yahoo.com' 
    mail from: 'info@myflix.com', to: address, subject: "Password Reset" 
  end

  def notify_on_new(user)
    @user = user
    address = (ENV["REAL_PRODUCTION"] == 'real_production')  ? @user.email  : 'rick.heller@yahoo.com' 
    mail from: 'info@myflix.com', to: address, subject: "Welcome to RickMyflix" 
  end

  def invite(invitation)
    @invitation = invitation
    address = (ENV["REAL_PRODUCTION"] == 'real_production')  ? @user.email  : 'rick.heller@yahoo.com' 
    mail from: 'info@myflix.com', to: address, subject: "Check out RickMyflix" 
  end

end

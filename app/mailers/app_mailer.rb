class AppMailer < ActionMailer::Base


  def send_forgot_password(user)
    @user = user
    mail from: 'info@myflix.com', to: find_address, subject: "Password Reset" 
  end

  def notify_on_new(user)
    @user = user
    mail from: 'info@myflix.com', to: find_address, subject: "Welcome to RickMyflix" 
  end

  def invite(invitation)
    @invitation = invitation
    mail from: 'info@myflix.com', to: find_address, subject: "Check out RickMyflix" 
  end

  def find_address
    if ENV["REAL_PRODUCTION"] == 'real_production'
      @user.email
    else
      'rick.heller@yahoo.com' #send to admin if staging, dev, or test 
    end
  end

end

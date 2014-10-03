class AppMailer < ActionMailer::Base

  def send_forgot_password(user)
    @user = user
    mail from: 'info@myflix.com', to: find_address(@user), subject: "Password Reset" 
  end

  def notify_on_new(user)
    @user = user
    mail from: 'info@myflix.com', to: find_address(@user), subject: "Welcome to RickMyflix" 
  end

  def invite(invitation)
    @invitation = invitation
    mail from: 'info@myflix.com', to: find_address(@invitation), subject: "Check out RickMyflix" 
  end

  def find_address(item)
    if ENV["REAL_PRODUCTION"] == 'real_production'
      item.email
    else
      'rick.heller@yahoo.com' #send to admin if staging, dev, or test 
    end
  end

end

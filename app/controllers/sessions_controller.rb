class SessionsController < ApplicationController

  def new
    redirect_to home_path if current_user
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user.present? && @user.authenticate(params[:password])
      if @user.locked 
        flash[:error] = "Your account is locked. Please contact customer service."
        redirect_to sign_in_path
      else
        session[:user_id] = @user.id
        redirect_to home_path, notice: "You are signed in"
      end
    else
      flash[:error] = "Invalid email or password"
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are signed out. Please close the browser window for extra security."
  end

end

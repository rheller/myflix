class UsersController < ApplicationController
  before_filter :logged_in?, except: [:new, :create, :new_with_invitation_token]

  def new
    @user = User.new
  end

  def new_with_invitation_token
    @invitation = Invitation.where(token: params[:token] ).first
    if @invitation.present?
      @user = User.new(email: @invitation.recipient_email)
      render "new"
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_params)
    response = UserSignUp.new(@user).sign_up(params)
    if response.successful?
      flash[:success] = "Thank you for joining!"
      redirect_to sign_in_path, notice: "Thank you for registering. Please sign in."
    else
      flash[:error] = response.error_message
      render "new"
    end

  end

  def show
    @user = User.find_by_id(params[:id])
  end 

  def user_params
     params.require(:user).permit(:email, :full_name, :password)
  end

 
end

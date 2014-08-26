class UsersController < ApplicationController


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
       redirect_to sign_in_path, notice: "You are signed up. Please log in"
     else
       render "new"
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :full_name, :password)
    end

end
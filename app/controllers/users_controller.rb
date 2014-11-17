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
    if @user.save

# the token is just a link to the potential charge. This charges it.
      charge = StripeWrapper::Charge.create(
        :amount => params[:amount],
        :currency => "usd",
        :card => params[:stripeToken],
        :description => "RickFlix Charge"
        )
      if  charge.successful?
         #AppMailer.notify_on_new(@user).deliver   #immediately
         AppMailer.delay.notify_on_new(@user)      #background via sidekiq
         handle_invitation
         redirect_to sign_in_path, notice: "You are signed up. Please log in"
      else
        flash[:error] = charge.error_message
        render "new"
      end
    else
      render "new"
    end
  end

  def show
    @user = User.find_by_id(params[:id])
  end 


  private

    def handle_invitation
       token = params[:invitation_token]
       if token.present?
         invitation = Invitation.where(token: token).first
         if invitation.present?
           inviter = invitation.inviter
           if inviter.present?
             inviter.follow(@user)
             @user.follow(inviter)
             invitation.update_column(:token, nil)
           end
         end
       end
    end

    def user_params
      params.require(:user).permit(:email, :full_name, :password)
    end

 
end

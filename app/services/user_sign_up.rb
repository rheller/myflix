class UserSignUp

  attr_reader :user, :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(params)
    if user.valid?
      response = StripeWrapper::Customer.create(
        :card => params[:stripeToken],
        :plan => "ricktestplan",
        :user => user
        )
      if response.successful?
         user.customer_token = response.customer_token
         user.save
         AppMailer.notify_on_new(user).deliver   #immediately

#      background processing requires 
#        redis-server /usr/local/etc/redis.conf
#        foreman start
#        http://localhost:5000/
#         AppMailer.delay.notify_on_new(@user)      #background via sidekiq
         handle_invitation(params)
         @status = :successful
         self
      else
        @status = :failed
        @error_message = response.error_message 
        self
      end
    else
      @status = :failed
      @error_message = "The user information looks invalid."
      self
    end
  end

  def successful?
    @status == :successful
  end

    private

    def handle_invitation(params)
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

end

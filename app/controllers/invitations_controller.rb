class InvitationsController < ApplicationController

  before_filter :logged_in?

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id) )
    if @invitation.save
      #AppMailer.delay.invite(@invitation)   #immediate
      AppMailer.delay.invite(@invitation)    #background via sidekiq
      flash[:notice] = 'Invitation Sent'
      redirect_to new_invitation_path
    else
      flash[:error] = 'Failed to send Invitation'
      render "new"
    end
  end


  private

    def invitation_params
      params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
    end

end

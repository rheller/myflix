class EmailInvitationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(invitation_id)
    invitation = Invitation.find(invitation_id)
    AppMailer.invite(invitation).deliver
  end
end

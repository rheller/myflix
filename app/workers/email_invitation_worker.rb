class EmailInvitationWorker
  include Sidekiq::Worker

  def perform(id)
    invitation = Invitation.find(id)
    AppMailer.invite(@invitation).deliver
  end
end

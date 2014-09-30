class EmailOnNewUserWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find(user_id)
    AppMailer.notify_on_new(user).deliver
  end
end

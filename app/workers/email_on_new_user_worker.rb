class EmailOnNewUserWorker
  include Sidekiq::Worker

  def perform(id)
    user = User.find(id)
    AppMailer.notify_on_new(user).deliver
  end
end

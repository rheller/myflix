CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    }
    config.fog_directory  = 'name_of_directory'                          # required
    #config.fog_public     = false                                        # optional, defaults to true
    #config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
  else
    config.storage = :file
    #not in test
    config.enable_processing = Rails.env.development?
  end
  
end

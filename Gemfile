source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap_form'
gem 'bcrypt-ruby'

gem 'sidekiq'
gem 'unicorn'
gem "sentry-raven" # for error monitoring
gem 'stripe' # for credit cards

gem 'paratrooper' #for deployment

gem 'carrierwave' #for uploading
gem 'fog' #for uploading to Amazon s3

gem 'mini_magick'

group :development do
  gem 'sqlite3'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails', '2.99'
  gem 'fabrication'
  gem 'faker'       
  gem 'pry'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end


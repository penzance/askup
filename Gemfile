source 'https://rubygems.org'
ruby '2.1.4'

gem 'rails', '4.1.4'
gem 'thin'  # one option for app server
gem 'puma'  # another option (for heroku)
gem 'turbolinks'
gem 'acts_as_tree'
gem 'cancancan', '~> 1.10'
gem 'devise'
gem 'figaro'

# Use SCSS, bootstrap, and Jquery for client-side code
gem 'bootstrap-sass'
gem 'sass-rails', '~> 4.0.3'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'spring'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  # Note: this gem sends logs to syslog instead of log/production.log
  gem 'rails_12factor'
end

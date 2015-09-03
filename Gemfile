source 'https://rubygems.org'

gem 'rails', '4.1.4'
gem 'turbolinks'
gem 'acts_as_tree'
gem 'cancancan', '~> 1.10'
gem 'devise'

# Use SCSS, bootstrap, and Jquery for client-side code
gem 'bootstrap-sass'
gem 'sass-rails', '~> 4.0.3'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'spring'
end

group :development, :test, :staging do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :staging, :production do
  gem 'thin'
end



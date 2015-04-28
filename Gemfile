Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source 'https://rubygems.org'

gem 'rails', github: 'rails/rails', branch: '4-2-stable'
gem 'rack-ssl-enforcer'
gem 'rack-cors'

# rails 4 compatibility
  gem 'protected_attributes', '1.0.8'
  gem 'activerecord-deprecated_finders'
# rails 4.2 compatibility
  gem 'responders', '~> 2.0'

# Database
  gem 'pg', '0.17.0'
  gem 'pg_search'

# Model extensions
  gem 'closure_tree', "4.2.4"
  gem 'brazilian-rails'
  gem 'remotipart', '~> 1.0'
  gem 'carrierwave'
  gem "friendly_id", "5.1.0.beta.1"
  gem 'acts-as-taggable-on'

# Presenters and objects for simplifying internal workflows
  gem 'draper', '~> 1.2.1'
  gem "active_model_serializers", github: 'rails-api/active_model_serializers', branch: 'master'
  gem "mustache" # used in store themes

# Components for forms and widgets
  gem 'devise', '~> 3.4.1'
  gem 'cancan'
  gem 'simple_form', '~> 3.1'
  gem 'kaminari'
  gem 'wicked', '~> 0.3' # wizard-like views
  gem 'mini_magick'
  gem 'mail_form', github: 'plataformatec/mail_form', ref: '9eb221a9c5e3f6dad6'

# HTTP API & endpoints
  gem 'doorkeeper'

# Assets and client stuff
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'therubyracer'
  gem 'uglifier', '~> 1.3.0'
  gem 'jquery-rails'
  gem 'ember-rails', '0.13.0'
  gem 'fancybox2-rails', '~> 0.2.4' # JS lib lightbox for zooming images

# Third-party connections
  gem "correios-frete", "~> 1.8.0"
  gem 'pag_seguro'
  gem 'postmark-rails'

# Sysops
  gem 'capistrano', '2.13.5'
  gem "airbrake"
  gem 'whenever', require: false

group :development do
  gem 'rvm-capistrano', require: false
  gem 'quiet_assets'
  gem 'better_errors'
  #gem 'binding_of_caller', '0.7.2'
  gem 'rails-dev-tweaks', '~> 1.1'
end

group :development, :test do
  gem 'rspec', '~> 2.14.1'
  gem 'rspec-rails', '~> 2.14.2'
  gem 'factory_girl_rails', require: false
  gem 'thin'
  gem 'pry'
  gem 'pry-nav'
  gem 'poltergeist', '1.4.1'
  gem 'konacha'
  gem 'ejs'
  gem 'qunit-rails'
  #gem 'web-console', '~> 2.0'
  gem 'awesome_print'
end

group :test do
  gem 'capybara'
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'launchy', '2.0.5'
  gem 'database_cleaner'
  gem 'timecop'

  # testing email deliveries
  gem 'capybara-email'
end

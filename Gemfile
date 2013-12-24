Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source 'https://rubygems.org'

gem 'rails', '~>4'

# rails 4 compatibility
  gem 'protected_attributes', '1.0.3'
  gem 'activerecord-deprecated_finders'

# Database
  gem 'pg', '0.17.0'
  gem 'pg_search'

# Model extensions
  gem 'closure_tree', "4.2.4"
  gem 'brazilian-rails'
  gem 'remotipart', '~> 1.0'
  gem 'carrierwave'
  gem 'activerecord-postgres-hstore', git: 'git://github.com/engageis/activerecord-postgres-hstore.git'
  gem "friendly_id", "~> 5.0.1"

# Presenters and objects for simplifying internal workflows
  gem 'draper', '~> 1.2.1'
  gem 'inherited_resources'
  gem "active_model_serializers", github: 'rails-api/active_model_serializers'
  gem "mustache" # used in store themes

# Components for forms and widgets
  gem 'devise', '~> 3.2.2'
  gem 'cancan'
  gem 'simple_form', "~> 3.0.1"
  gem 'kaminari'
  gem 'wicked', '~> 0.3' # wizard-like views
  gem 'mini_magick'
  gem 'mail_form', github: 'plataformatec/mail_form', ref: '9eb221a9c5e3f6dad6'

# Assets and client stuff
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'therubyracer', '0.11.4'
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
  gem 'rvm-capistrano'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller', '0.7.2'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.13'
  gem 'thin'
  gem 'pry'
  gem 'pry-nav'
  gem 'poltergeist', '1.4.1'
  gem 'konacha'
  gem 'ejs'
  gem 'qunit-rails'
  gem 'teaspoon'
end

group :test do
  gem 'capybara'
  gem 'shoulda', '3.5.0'
  gem 'shoulda-matchers', '~> 2.1.0'
  gem 'factory_girl', '~> 4'
  gem 'launchy', '2.0.5'
  gem 'database_cleaner'
  gem 'timecop'

  # testing email deliveries
  gem 'capybara-email'
end

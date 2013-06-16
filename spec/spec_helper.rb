ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/contracts/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.filter_run wip: true
  config.run_all_when_everything_filtered = true
  config.alias_it_should_behave_like_to :it_obeys_the, 'it obeys the'

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros
  config.include AcceptanceSteps
  config.include CapybaraHelpers::DomainHelpers
  config.include CapybaraHelpers::CartHelpers
  config.include CapybaraHelpers::CheckoutHelpers
  config.include CapybaraHelpers::CheckoutStubsHelpers
  config.include CapybaraHelpers::StubsHelpers
  config.include Helpers::FactoryGirlHelpers

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

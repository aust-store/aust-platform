require 'capybara/poltergeist'
require "spec_helper"

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 2

Capybara.configure do |config|
  config.always_include_port = true
end

RSpec.configure do |config|
  config.include CapybaraHelpers::DomainHelpers

  config.before(:each) do
    switch_to_main_domain
    # This is needed because we use some logic for iPhones and iPads, so we better
    # use Chrome on Desktop as default
    chrome = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.99 Safari/537.22"
    if Capybara.current_session.driver.respond_to? :header
      Capybara.current_session.driver.header 'USER_AGENT', chrome
    else
      Capybara.current_session.driver.headers = { 'USER_AGENT' => chrome }
    end
  end
end

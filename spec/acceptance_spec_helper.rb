require 'capybara/poltergeist'
require "spec_helper"

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 2
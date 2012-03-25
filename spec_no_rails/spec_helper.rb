require "rubygems"
require "bundler/setup"
require "simple_presenter"

Dir["./spec_no_rails/support/**/*.rb"].each { |x| require x }
Dir["./lib/store/domain_object/**/*.rb"].each { |x| require x }

RSpec.configure do |c|
  c.filter_run wip: true
  c.run_all_when_everything_filtered = true
end

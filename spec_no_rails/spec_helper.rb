Dir["./app/business/**/*"].each { |x| require x }

RSpec.configure do |c|
  c.filter_run wip: true
  c.run_all_when_everything_filtered = true
end
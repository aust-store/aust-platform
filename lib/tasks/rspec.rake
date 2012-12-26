if Rails.env.development?
  require 'rubygems'
  require 'bundler/setup'

  require 'rake'
  require 'rspec/core/rake_task'

  task(:spec).clear
  task(:default).clear

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end

  desc 'Run the entire suite of tests.'
  task :run_suite do |t|
    sh "bundle exec rake konacha:run"
    puts ""
    sh "bundle exec rspec -O ~/.rspec --color --format progress --no-drb spec/"
    puts ""
    sh "bundle exec rspec -O ~/.rspec --color --format progress --no-drb spec_integration/"
  end

  desc 'Default: run specs.'
  task :default => :run_suite
end

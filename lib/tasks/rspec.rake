require 'rake'
require 'rspec/core/rake_task'

class Rake::Task
  def abandon
    @actions.clear
  end
end

Rake::Task[:spec].abandon

desc 'Run the entire suite of tests.'
task :run_suite do |t|
  #sh "rspec spec/unit && bundle exec rspec spec/integration spec/acceptance"
  sh "rspec --no-drb spec/unit"
  sh "bundle exec rspec spec/integration"
  sh "bundle exec rspec spec/acceptance"
end

namespace :spec do
  desc "Run acceptance specs"
  RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.pattern = "./spec/acceptance/**/*_spec.rb"
  end
end

desc "Generate code coverage"
RSpec::Core::RakeTask.new(:coverage) do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end

desc 'Default: run specs.'
task :default => :run_suite


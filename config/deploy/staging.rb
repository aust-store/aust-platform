require 'bundler/capistrano'

set :deploy_to, "/var/rails/#{application}"
set :rails_env, "staging"
set :user, "deployer"

default_run_options[:pty] = true
role :web, "50.116.3.20"
role :app, "50.116.3.20"
role :db,  "50.116.3.20", :primary => true

require "rvm/capistrano"
require 'bundler/capistrano'

set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"
set :user, "deploy"

default_run_options[:pty] = true
role :web, "74.207.232.56"
role :app, "74.207.232.56"
role :db,  "74.207.232.56", :primary => true


set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"
set :branch, "production"
set :user, "deploy"

default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash --login'
role :web, "74.207.232.56"
role :app, "74.207.232.56"
role :db,  "74.207.232.56", :primary => true

#set :default_environment, {
#  'PATH' => "/home/deploy/.rvm/gems/ruby-2.0.0-p247/bin/:$PATH"
#}

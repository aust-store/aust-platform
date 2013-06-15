require 'capistrano/ext/multistage'
require 'bundler/capistrano'
load "deploy/assets"

set :application, "store"
set :repository,  "git@github.com:kurko/store.git"
set :deploy_to, proc { "/var/rails/#{application}" }
set :stages, %w(staging production)
set :default_stage, "staging"

set :scm, :git

set :use_sudo, false
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :scm_verbose, true

default_run_options[:pty] = true
role :web, "50.116.3.20"                          # Your HTTP server, Apache/etc
role :app, "50.116.3.20"                          # This may be the same as your `Web` server
role :db,  "50.116.3.20", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :symlinks do
  task :database do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :uploads do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
end

after "deploy:finalize_update", "symlinks:database"
after "deploy:finalize_update", "symlinks:uploads"
after "setup_database:symlink_config", "deploy:migrate"

        require './config/boot'
        require 'airbrake/capistrano'

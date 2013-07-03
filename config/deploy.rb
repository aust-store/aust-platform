require 'capistrano/ext/multistage'
load "deploy/assets"

set :application, "store"
set :repository,  "git@github.com:kurko/store.git"
set :stages, %w(staging production)
set :default_stage, "staging"
set :user, "deploy"

set :use_sudo, false
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :scm_verbose, true

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

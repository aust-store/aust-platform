require 'bundler/capistrano'
load "deploy/assets"

set :application, "store"
set :repository,  "git@github.com:kurko/store.git"
set :deploy_to, proc { "/var/rails/#{application}" }
set :user, `whoami`.gsub(/\n/, "")

set :scm, :git

set :use_sudo, true
set :scm, :git
set :deploy_via, :remote_cache
set :scm_verbose, true
#set :domain, "example.com"

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

namespace :setup_database do
  task :symlink_config do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "setup_database:symlink_config"
after "setup_database:symlink_config", "deploy:migrate"

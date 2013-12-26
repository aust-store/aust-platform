#!/usr/bin/env rake
# encoding: utf-8
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Store::Application.load_tasks

namespace :test do
  task :qunit do
    pid = Process.spawn("rackup -p 9294")

    begin
      sleep(5)
      sh("phantomjs runner.js http://127.0.0.1:9294/qunit") do |ok, res|
        raise "Failed!" unless ok
      end
    ensure
      Process.kill("TERM", pid)
    end

  end
end

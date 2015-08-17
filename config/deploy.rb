require 'airbrake/capistrano3'
require 'byebug'
require 'capistrano/sidekiq'

# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'projectmosul'
set :repo_url, 'git@github.com:neshmi/projectmosul.git'
set :passenger_restart_command, 'touch'
set :passenger_restart_options, -> { "#{deploy_to}/current/tmp/restart.txt" }
set :log_level, :debug

set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :keep_releases, 5

# set :sidekiq_worker, -> { fetch(:sidekiq_worker) }

after 'deploy:finished', 'airbrake:deploy'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

before 'deploy:updating', 'sidekiq:quiet'
before 'deploy:restart',  'sidekiq:restart'

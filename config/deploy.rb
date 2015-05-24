require 'airbrake/capistrano3'

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

after 'deploy:finished', 'airbrake:deploy'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

namespace :sidekiq do
  desc 'Start the sidekiq workers via Upstart'
  task :start do
    sudo 'start staging-worker-1'
  end
 
  desc 'Stop the sidekiq workers via Upstart'
  task :stop do
    sudo 'stop staging-worker-1 || true'
  end
 
  desc 'Restart the sidekiq workers via Upstart'
  task :restart do
    sudo 'stop staging-worker-1 || true'
    sudo 'start staging-worker-1'
  end
 
  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet do
    pid_file       = "#{current_path}/tmp/pids/sidekiq.pid"
    sidekiqctl_cmd = "bundle exec sidekiqctl"
    run "if [ -d #{current_path} ] && [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then cd #{current_path} && #{sidekiqctl_cmd} quiet #{pid_file} ; else echo 'Sidekiq is not running'; fi"
  end
end
 
before 'deploy:update_code', 'sidekiq:quiet'
after  'deploy:stop',        'sidekiq:stop'
after  'deploy:start',       'sidekiq:start'
before 'deploy:restart',     'sidekiq:restart'

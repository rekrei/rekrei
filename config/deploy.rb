require 'airbrake/capistrano3'
require 'byebug'

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

namespace :sidekiq do
  def sidekiq_pid
    File.join(shared_path,'tmp','pids','sidekiq.pid')
  end

  def pid_file_exists?
    test(*("[ -f #{sidekiq_pid} ]").split(' '))
  end

  def pid_process_exists?
    pid_file_exists? and test(*("kill -0 $( cat #{sidekiq_pid} )").split(' '))
  end

  def sidekiqctl_cmd 
    "bundle exec sidekiqctl"
  end

  def sidekiq_worker
    fetch :sidekiq_worker
  end

  desc 'Start the sidekiq workers via Upstart'
  task :start do
    on roles(:app) do
      if !pid_process_exists?
        execute :sudo, "/sbin/start #{sidekiq_worker}"
      end
    end
  end

  desc 'Stop the sidekiq workers via Upstart'
  task :stop do
    on roles(:app) do
      if pid_process_exists?
        execute :sudo, "/sbin/stop #{sidekiq_worker}"
        execute "rm #{sidekiq_pid}"
      end
    end
  end

  desc 'Restart the sidekiq workers via Upstart'
  task :restart do
    on roles(:app) do
      invoke "sidekiq:stop"
      invoke "sidekiq:start"
    end
  end

  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet do
    sidekiqctl_cmd = "bundle exec sidekiqctl"
    run "if [ -d #{current_path} ] && [ -f #{sidekiq_pid} ] && kill -0 `cat #{sidekiq_pid}`> /dev/null 2>&1; then cd #{current_path} && #{sidekiqctl_cmd} quiet #{sidekiq_pid} ; else echo 'Sidekiq is not running'; fi"
  end
end
 
before 'deploy:updating', 'sidekiq:quiet'
before 'deploy:restart',  'sidekiq:restart'

role :app, %w(mosul@staging.projectmosul.org)
role :web, %w(mosul@staging.projectmosul.org)
role :db,  %w(mosul@staging.projectmosul.org)


set :user, 'mosul'
set :deploy_to, '/home/mosul/apps/projectmosul-staging'
set :sidekiq_worker, 'staging-worker-1'
role :app, %w(mosul@projectmosul.org)
role :web, %w(mosul@projectmosul.org)
role :db,  %w(mosul@projectmosul.org)

set :deploy_to, '/home/mosul/apps/projectmosul'
set :user, 'mosul'

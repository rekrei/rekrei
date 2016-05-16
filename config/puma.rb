threads 1, Integer(ENV['MAX_THREADS'] || 6)

preload_app!

rackup      DefaultRackup
port        3000
environment ENV['RACK_ENV'] || 'development'


on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end

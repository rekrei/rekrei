Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: "projectmosul_#{Rails.env}" }
end  


Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: "projectmosul_#{Rails.env}" }

  database_url = ENV['DATABASE_URL']
  if database_url
    ENV['DATABASE_URL'] = "#{database_url}?pool=25"
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  end
end
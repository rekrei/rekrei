def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

Devise.setup do |config|
  config.secret_key = secure_token
  config.mailer_sender = ENV['SENDER_EMAIL']
  require 'devise/orm/active_record'
  config.authentication_keys = [:username]
  config.case_insensitive_keys = [:username]
  config.strip_whitespace_keys = [:username]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.confirmation_keys = [:username]
  config.remember_for = 6.weeks
  config.extend_remember_period = true
  config.password_length = 8..128
  config.email_regexp = /\A[^@]+@[^@]+\z/
  config.reset_password_keys = [:email]
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end

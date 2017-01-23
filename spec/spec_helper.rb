# require 'simplecov'
# SimpleCov.start do
#   add_filter 'vendor/'
# end
require 'coveralls'
Coveralls.wear!

require 'single_cov'
SingleCov.setup :rspec

require 'codeclimate-test-reporter'
require 'rspec/active_job'

CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.include(RSpec::ActiveJob)
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.after(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
    ActiveJob::Base.queue_adapter.performed_jobs = []
  end

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

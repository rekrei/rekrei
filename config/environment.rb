# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Projectmosul::Application.initialize!

if !Rails.env.development
  Rails.logger = Le.new('a66c30f9-b5fc-4560-b62e-06e7fee0c660')
else
  Rails.logger = Le.new('a66c30f9-b5fc-4560-b62e-06e7fee0c660', :debug => true, :local => true)
end

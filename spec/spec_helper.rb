# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'pry'
require 'ffaker' # Required for factories.
require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include FactoryGirl::Syntax::Methods
end

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'pry'
require 'spree/testing_support/factories'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods
end

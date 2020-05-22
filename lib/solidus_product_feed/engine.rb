# frozen_string_literal: true

require 'spree/core'
require 'solidus_product_feed'

module SolidusProductFeed
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_product_feed'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end

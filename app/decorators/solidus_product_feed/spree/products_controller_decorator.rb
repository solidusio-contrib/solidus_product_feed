# frozen_string_literal: true

module SolidusProductFeed
  module Spree
    module ProductsControllerDecorator
      def self.prepended(klass)
        klass.respond_to :rss, only: :index
      end

      def index
        load_feed_products if request.format.rss?
        super
      end

      private

      def load_feed_products
        @feed_products = ::Spree::Product.all.map(&SolidusProductFeed.feed_product_class.method(:new))
      end

      ::Spree::ProductsController.prepend self
    end
  end
end

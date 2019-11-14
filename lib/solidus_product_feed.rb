require 'spree_core'
require 'deface'
require 'solidus_product_feed/engine'

module SolidusProductFeed
  class << self
    attr_writer :title, :link, :description, :language, :feed_product_class

    def configure
      yield self
    end

    def evaluate(value, view_context)
      value.respond_to?(:call) ? value.call(view_context) : value
    end

    def title
      @title ||= -> (view) { view.current_store.name }
    end

    def link
      @link ||= -> (view) { "http://#{view.current_store.url}" }
    end

    def description
      @description ||= -> (view) { "Find out about new products on http://#{view.current_store.url} first!" }
    end

    def language
      @language ||= 'en-us'
    end

    def feed_product_class
      (@feed_product_class ||= 'Spree::FeedProduct').constantize
    end
  end
end

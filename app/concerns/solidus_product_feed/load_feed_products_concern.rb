module SolidusProductFeed
  module LoadFeedProductsConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def prepended(klass)
        klass.respond_to :rss, only: :index
      end
    end

    def index
      load_feed_products if request.format.rss?
      super
    end

    private

    def load_feed_products
      @feed_products = Spree::Product.select(&:available?).map do |prod|
        Spree::FeedProductPresenter.new(view_context, prod)
      end
    end
  end
end

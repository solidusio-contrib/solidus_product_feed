Spree::ProductsController.class_eval do
  before_action :load_feed_products, only: :index, if: -> { request.format.rss? }

  respond_to :rss, only: :index

  private

  def load_feed_products
    @feed_products = Spree::Product.all.map(&Spree::FeedProduct.method(:new))
  end
end

module SolidusProductFeed
  class ProductsController < Spree::StoreController
    respond_to :rss

    def index
      @products = Spree::Product.all
      @feed_products = @products.map{ |p| Spree::FeedProduct.new(p) }
    end
  end
end

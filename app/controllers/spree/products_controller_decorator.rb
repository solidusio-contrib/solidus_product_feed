Spree::ProductsController.prepend Module.new do
  def self.prepended(klass)
    klass.respond_to :rss, only: :index
    klass.before_filter :check_rss, only: :index
  end

  def check_rss
    if request.format.rss?
      @products = Spree::Product.all
      respond_to do |format|
        format.rss { render 'spree/products/index.rss', layout: false }
      end
    end
  end
end

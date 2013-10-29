Spree::ProductsController.class_eval do
  respond_to :rss, :only => [:index]
  before_filter :check_rss, only: :index

  def check_rss
    if request.format.rss?
      @products = Spree::Product.all
      respond_to do |format|
        format.rss
      end
    end
  end

  caches_page :index, :if => Proc.new {|c| c.request.format.rss? }, :expires_in => 1.days
end

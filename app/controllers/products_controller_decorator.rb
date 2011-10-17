ProductsController.class_eval do
  respond_to :rss, :only => [:index]
end

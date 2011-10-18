ProductsController.class_eval do
  respond_to :rss, :only => [:index]

  caches_page :index, :if => Proc.new {|c| c.request.format.rss? }
end

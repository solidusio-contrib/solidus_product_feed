Spree::Core::Engine.routes.draw do
  get '/product_feed', as: :product_feed, format: :rss
end

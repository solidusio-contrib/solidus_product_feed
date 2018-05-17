Spree::Core::Engine.routes.draw do
  get '/product_feed', to: 'solidus_product_feed/products#index', as: :product_feed, format: :rss
end

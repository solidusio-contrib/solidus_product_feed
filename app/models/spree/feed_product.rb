module Spree
  class FeedProduct
    attr_reader :product

    def initialize(product)
      @product = product
    end

    def schema
      {
        'g:id' => id,
        'title' => title,
        'description' => description,
        'link' => link,
        'g:image_link' => image_link,
        'g:condition' => condition,
        'g:price' => price,
        'g:availability' => availability,
        'g:brand' => brand,
        'g:mpn' => mpn,
        'category' => category,
      }
    end

    def id
      product.id
    end

    def title
      product.name
    end

    def description
      product.description
    end

    def link
      -> (view) { view.product_url(product) }
    end

    def image_link
      return unless product.images.any?

      product.images.first.attachment.url(:large)
    end

    # Must be "new", "refurbished", or "used".
    def condition
      "new"
    end

    def price
      Spree::Money.new(product.price).money.format(symbol: false, with_currency: true)
    end

    def availability
      product.master.in_stock? ? 'in stock' : 'out of stock'
    end

    def brand; end

    def mpn
      product.master.sku
    end

    def category
      # Must be selected from https://support.google.com/merchants/answer/1705911
    end
  end
end

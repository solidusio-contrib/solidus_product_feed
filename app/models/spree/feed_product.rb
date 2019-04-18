module Spree
  class FeedProduct
    attr_reader :product

    def initialize(product)
      @product = product
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

    # Must be selected from https://support.google.com/merchants/answer/1705911
    def category; end

    def brand; end

    # Must be "new", "refurbished", or "used".
    def condition
      "new"
    end

    def price
      Spree::Money.new(product.price)
    end

    def image_link
      return unless product.images.any?

      product.images.first.attachment.url(:large)
    end

    def availability
      product.master.in_stock? ? 'in stock' : 'out of stock'
    end

    def mpn
      product.master.sku
    end
  end
end

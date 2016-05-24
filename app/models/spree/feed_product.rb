module Spree
  class FeedProduct
    attr_reader :product

    def initialize(product)
      @product = product
    end

    def id
      product.sku.blank? ? product.id : product.sku
    end

    def title
      product.name
    end

    def description
      product.description
    end

    # Must be selected from https://support.google.com/merchants/answer/1705911
    def category
    end

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

    def shipping_weight
      "#{product.weight} lbs"
    end
  end
end

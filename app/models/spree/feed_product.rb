module Spree
  class FeedProduct
    attr_reader :product

    def initialize(product)
      @product = product
    end

    def id
      product.id
    end

    # FIXME: Must be "new", "refurbished", or "used".
    def condition
      "retail"
    end

    def price
      product.price.to_s
    end

    def image_link
      return unless product.images.any?
      product.images.first.attachment.url(:large)
    end

    def published_at
      (product.available_on || product.created_at).strftime("%a, %d %b %Y %H:%M:%S %z")
    end

    def description
      product.description
    end

    def title
      product.name
    end
  end
end

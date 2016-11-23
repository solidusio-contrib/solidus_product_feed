module Spree
  class SchemaError < StandardError
    def initialize msg, product
      super("Missing mandatory #{msg}. Skipping feed entry for #{product.inspect}")
    end
  end

  class FeedProductPresenter
    # @!attribute schema
    #   @return [Array <Symbol, Hash>] the nested schema to use in xml generation
    #
    # @!attribute properties
    #   @return [Array <Symbol>] the product properties list to use in accessor creation.
    attr_accessor :schema, :properties
    # Creates FeedProductPresenter for presenting products as items
    # in RSS feed for Google Merchant
    #
    # @param view [ActionView view context] the view being rendered.
    #
    # @param product [Spree::Product] the product to display. It must
    #   have its own landing page, which is why variants are not supported
    #   at this time.
    #
    # @param properties [Array <Symbol>] all of the product data which is
    #   obtained from the product.properties
    def initialize(view, product, properties: nil)

      @view = view
      @product = product
      @schema = [
        :id, :title, :description, :image_link, :price, :availability,
        :identifier_exists, :link, :condition,
        {parent: :shipping, schema: [:price]},
        {parent: :tax, schema: [:rate]},
      ]

      # Automatically include any product_property which defines
      # values for any of the following:
      @properties = [:brand, :gtin, :mpn, :google_product_category,
                     :adult, :multipack, :is_bundle, :energy_efficiency_class,
                     :age_group, :color, :gender, :material, :pattern, :size,
                     :size_type, :size_system, :item_group_id, :product_type,
                     :unit_pricing_measure, :unit_pricing_base_measure]

      # For each property listed, if the product has a property
      # associated with it which matches, create an instance method
      # of the same name which retrieves the property value.
      @properties.each do |prop|
        next unless @product.property(prop.to_s)
        @schema << prop
        self.class.send(:define_method, prop) do
          @product.property(prop.to_s)
        end
      end
    end

    # Creates an <item> RSS feed entry of the
    # product, corresponding with Google's requested schema. If a
    # mandatory element of the schema is missing, a SchemaError is
    # raised, the entire <item> entry for this product is skipped,
    # and an error is logged to the configured log file or STDERR.
    #
    # @param xml [Builder::XmlMarkup]
    # @return String, the xml <item> tag and content for this product.
    def item xml
      @xml ||= xml
      valid = begin
                draw(schema: schema, parent: nil, validate_only: true)
              rescue SchemaError => e
                SolidusProductFeed.logger.warn { e.message }
                false
              end

      if valid
        @xml.item do
          draw(schema: schema, parent: nil)
        end
      end
    end

    private

    # Computes the parameters for an xml tag of <datum>
    #
    # @param entry [Symbol] the name of the xml tag
    #   and instance method name which computes it's contents.
    # @param parent [Symbol] the name of the surrounding tag, or nil
    #   if none.
    # @return [Array <String>] the tag name and content for an
    #   xml tag.
    def tag_params_for parent, entry
      ["g:#{entry}", self.send(scoped_name(parent, entry))]
    end

    # Recursively produces xml tags representing product for
    # an xml feed.
    #
    # @param feed_product [Spree::FeedProductPresenter] the product to display
    # @param schema [Array <Symbol, Hash>] the schema to draw
    # @param parent [:Symbol, nil] the parent tag to nest within.
    # @return [String] the xml formatted string content for this products
    #   <item> tag
    def draw(schema:, parent:, validate_only: false)
      schema.each do |entry|
        if entry.is_a? Symbol
          type, content = tag_params_for(parent, entry)
          @xml.tag! type, content unless validate_only
        else
          if validate_only
            draw(**entry, validate_only: true)
          else
            @xml.tag! "g:#{entry[:parent]}" do
              draw(**entry)
            end
          end
        end
      end
    end

    # Creates scoped method names.
    #
    # @param parent [Symbol] the parent scope
    # @param name [Symbol] the method name
    # @return [Symbol] the fully scoped method name.
    def scoped_name parent, name
      if parent.present?
        "#{parent}_#{name}".to_sym
      else
        name
      end
    end

    # Gives the formatted price of the product
    #
    # @return [String] the products formatted price.
    def price
      raise SchemaError.new("price", @product) unless @product.price
      @price ||= Spree::Money.new(@product.price)
      @price.money.format(symbol: false, with_currency: true)
    end

    # Gives the URI of the product
    #
    # @return [String] the uri of the product.
    def link
      @product_url ||= @view.product_url(@product)
      raise SchemaError.new("link", @product) unless @product_url.present?
      @product_url
    end

    # Gives the formatted price of shipping for the product
    #
    # @return [String] the configured base shipping price, or
    #   the minimum shipping available for this product.
    def shipping_price
      @shipping_price ||=
        if bsp = Rails.configuration.try(:base_shipping_price)
          Spree::Money.new(bsp)
        else
          Spree::Money.new(
            @product.shipping_category.shipping_methods
            .flat_map(&:shipping_rates)
            .sort_by(&:cost)
            .first
            .cost)
        end
      raise SchemaError unless @shipping_price.present?
      @shipping_price.money.format(symbol: false, with_currency: true)
    end

    # @return [String] the product sku
    def id
      @id ||= @product.sku
      raise SchemaError.new("id", @product) unless @id
      @id
    end

    # @return [String] the product name
    def title
      @title ||= @product.name
      raise SchemaError.new("title", @product) unless @title.present?
      @title
    end

    # @return [String] the product description
    def description
      @description ||= @product.description
      raise SchemaError.new("description", @product) unless @description.present?
      @description
    end

    # Returns the configured basic condition for products, or
    # this products condition via product.property.
    #
    # @return [String] the product condition.
    def condition
      @condition ||=
        Rails.configuration.try(:base_product_condition) || @product.property('condition') || 'new'
      raise SchemaError.new("condition", @product) unless @condition.present?
      @condition
    end

    # Computes whether this product has a brand
    # and either, a GTIN number or an MPN number.
    #
    # @return [String] `no`, `yes`
    def identifier_exists
      ( brand? && (gtin? || mpn?) ) ? 'yes' : 'no'
    end

    # Gives the mandatory URL of the image of the product.
    #
    # @return [String, nil] a URL of an image of the product
    def image_link
      @images ||= @product.images.any? ? @product.images : @product.variants.flat_map { |v| v.images }
      raise SchemaError.new("image link", @product) unless @images.length > 0
      @image_link ||= @images.first.attachment.url(:large)
      @image_link
    end

    # Computes the availability status of the product
    # @return [String] the availability status of the product.
    #   One of `in stock`, `out of stock`.
    def availability
      @availability ||= @product.stock_items.any?(&:available?) ? 'in stock' : 'out of stock'
      raise SchemaError.new("availability", @product) unless @availability.present?
      @availability
    end

    # Returns the most frequently used tax rate for this item. If no tax rate
    # has been applied to the variant, the first tax rate is chosen.
    #
    # @return [BigDecimal] the tax rate in precent.
    def tax_rate
      rates = Spree::TaxRate.joins(:adjustments)
        .joins("INNER JOIN spree_line_items "\
        "ON spree_adjustments.adjustable_id = spree_line_items.id "\
        "AND spree_adjustments.adjustable_type = 'Spree::LineItem'")
        .where("spree_line_items.variant_id = ?", @product.master.id)
        .group("spree_tax_rates.id")

      @tax_rate ||=
        if rates.present?
          tr_id = rates.count.map(&:flatten).sort_by { |id, count| -count }.first.first
          Spree::TaxRate.find(tr_id).amount * 100.0
        else
          @product.master.tax_category.tax_rates.first.amount * 100.0
        end
      raise SchemaError.new("tax rate", @product) unless @tax_rate.present?
      @tax_rate
    end

    # Computes whether or not a product property for brand is present.
    #
    # @return [TrueClass, FalseClass]
    def brand?
      @product.property('brand').present?
    end

    # Computes where or not a product property for gtin is present.
    #
    # @return [TrueClass, FalseClass]
    def gtin?
      @product.property('gtin').present?
    end

    # Computes where or not a product property for mpn is present.
    #
    # @return [TrueClass, FalseClass]
    def mpn?
      @product.property('mpn').present?
    end
  end
end

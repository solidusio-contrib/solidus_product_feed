require "spec_helper"

RSpec.describe Spree::FeedProductPresenter do
  let!(:product) do
    create :product,
      name: "2 Hams 20 Dollars",
      description: "As seen on TV!"
  end

  let!(:shipping_method_1) { create :shipping_method }
  let!(:cheapest_shipping_method) { create :free_shipping_method }
  let!(:shipping_rate_1) do
    create :shipping_rate, cost: 11.1, shipping_method: shipping_method_1
  end
  let!(:shipping_rate_2) do
    create :shipping_rate, cost: 22.2, shipping_method: shipping_method_1
  end
  let!(:cheapest_shipping_rate) do
    create :shipping_rate, cost: 0.0, shipping_method: cheapest_shipping_method
  end

  let!(:category_property) { create :property,
                             name: 'google_product_category',
                             presentation: 'Google Product Category' }

  let!(:condition_property) { create :property,
                             name: 'condition',
                             presentation: 'Condition' }

  let!(:product_category_property) { create :product_property,
                                     product: product,
                                     property: category_property,
                                     value: 'test value' }

  let!(:product_condition_property) { create :product_property,
                                     product: product,
                                     property: condition_property,
                                     value: 'refurbished' }

  let(:feed_product) { described_class.new(ActionView::Base.new, product) }

  describe "#id" do
    subject { feed_product.send :id }

    it "delegates to the product's SKU" do
      expect(subject).to eq product.sku
    end
  end

  describe "#google_product_category" do
    subject { feed_product.send :google_product_category }
    it { is_expected.to eq 'test value' }
  end

  describe "#condition" do
    subject { feed_product.send :condition }
    it { is_expected.to eq "refurbished" }
  end

  describe "#price" do
    subject { feed_product.send :price }
    it { is_expected.to eq '19.99 USD' }
  end

  describe "#image_link" do
    subject { feed_product.send :image_link }
    context "when the product has images" do
      before do
        Spree::Image.create! viewable: product.master, attachment_file_name: 'hams.png'
      end
      it { is_expected.to eq '/spree/products/1/large/hams.png' }
    end

    context "when the product doesn't have images" do
      it "raises a schema error" do
        expect { subject }.to raise_error(Spree::SchemaError)
      end
    end
  end

  describe "#description" do
    subject { feed_product.send :description }
    it { is_expected.to eq "As seen on TV!" }
  end

  describe "#title" do
    subject { feed_product.send :title }
    it { is_expected.to eq "2 Hams 20 Dollars" }
  end

  describe "#scoped_name" do
    context "when parent is not nil" do
      subject { feed_product.send :scoped_name, :shipping, :price }
      it { is_expected.to eq :shipping_price }
    end
    context "when parent is nil" do
      subject { feed_product.send :scoped_name, nil, :price }
      it { is_expected.to eq :price }
    end
  end

  describe "#shipping_price" do
    subject { feed_product.send :shipping_price }
    it "selects the cheapest shipping rate" do
      expect(subject).to eq(Spree::Money.new(cheapest_shipping_rate.cost)
        .money.format(symbol: false, with_currency: true))
    end
  end

  context "when brand property exists" do
    let!(:brand_property) { create :property, name: 'brand',
                           presentation: "Brand" }

    let!(:brand) { create :product_property, product: product,
                   property: brand_property, value: 'Pamasaonic'}

    describe "brand?" do
      subject { feed_product.send :brand? }

      it { is_expected.to be_truthy }
    end

    describe "#identifier_exists" do
      subject { feed_product.send :identifier_exists }

      it { is_expected.to eq 'no' }

      context "when gtin exists" do
        let(:gtin_property) { create :property, name: 'gtin',
                              presentation: 'GTIN' }
        let!(:gtin) { create :product_property, product: product,
                      property: gtin_property,
                      value: 123 }

        it { is_expected.to eq 'yes' }

        describe "#gtin?" do
          subject { feed_product.send :gtin? }

          it { is_expected.to be_truthy }
        end
      end

      context "when mpn exists" do
        let(:mpn_property) { create :property, name: 'mpn',
                              presentation: 'MPN' }
        let!(:mpn) { create :product_property, product: product,
                      property: mpn_property,
                      value: 123 }

        it { is_expected.to eq 'yes' }

        describe "#mpn?" do
          subject { feed_product.send :mpn? }

          it { is_expected.to be_truthy }
        end
      end
    end
  end

  context "when brand property does not exist" do
    describe "#identifier_exists" do
      subject { feed_product.send :identifier_exists }

      it { is_expected.to eq 'no' }

      context "when gtin exists" do
        let(:gtin_property) { create :property, name: 'gtin',
                              presentation: 'GTIN' }
        let!(:gtin) { create :product_property, product: product,
                      property: gtin_property,
                      value: "GTIN123" }

        it { is_expected.to eq 'no' }

        describe "#gtin" do
          subject { feed_product.send :gtin }
          it { is_expected.to eq "GTIN123" }
        end
      end

      context "when mpn exists" do
        let(:mpn_property) { create :property, name: 'mpn',
                              presentation: 'MPN' }
        let!(:mpn) { create :product_property, product: product,
                      property: mpn_property,
                      value: "MPN123" }

        it { is_expected.to eq 'no' }

        describe "#mpn" do
          subject { feed_product.send :mpn }
          it { is_expected.to eq "MPN123" }
        end
      end
    end
  end

  describe "#tax_rate" do
    subject { feed_product.send :tax_rate }

    let!(:tax_rate_1) { create :tax_rate, tax_category: product.tax_category }
    let!(:tax_rate_2) { create :tax_rate, tax_category: product.tax_category,
                       amount: 0.5 }
    context "when there are tax rates on line items for this product" do
      let(:line_item_rate_1) { create :line_item, product: product,
                                variant: product.master }

      let(:line_items_rate_2) { create_list :line_item, 3, product: product,
                                variant: product.master }

      let!(:adjustment_1) { create :tax_adjustment, adjustable: line_item_rate_1,
                           source: tax_rate_1 }

      let!(:adjustment_2) {
        line_items_rate_2.map do |line_item_rate_2|
          create :tax_adjustment, adjustable: line_item_rate_2, source: tax_rate_2
        end
      }

      it { is_expected.to eq tax_rate_2.amount * 100.0 }
    end

    context "when there are no tax rates applied to any line item for this product" do
      it { is_expected.to eq tax_rate_1.amount * 100.0 }
    end

  end

  describe "tag_params_for" do
    subject { feed_product.send :tag_params_for, nil, :price }

    it { is_expected.to contain_exactly("g:price", feed_product.send(:price)) }
  end

end

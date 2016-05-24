require "spec_helper"

RSpec.describe Spree::FeedProduct do
  let(:feed_product) { described_class.new(product) }
  let(:product) do
    create :product,
      name: "2 Hams 20 Dollars",
      description: "As seen on TV!"
  end

  describe "#id" do
    subject { feed_product.id }

    context "when the product a SKU" do
      let(:product) { create(:product, sku: 'LEGIT-5K00') }
      it { is_expected.to eq 'LEGIT-5K00' }
    end

    context "when the product doesn't have a SKU" do
      let(:product) { create(:product, sku: "") }
      it "delegates to the product's id" do
        expect(subject).to eq product.id
      end
    end
  end

  describe "#category" do
    subject { feed_product.category }
    it { is_expected.to be_nil }
  end

  describe "#condition" do
    subject { feed_product.condition }
    it { is_expected.to eq "new" }
  end

  describe "#price" do
    subject { feed_product.price }
    it { is_expected.to eq Spree::Money.new(19.99, currency: 'USD') }
  end

  describe "#image_link" do
    subject { feed_product.image_link }
    context "when the product has images" do
      before { Spree::Image.create! viewable: product.master, attachment_file_name: 'hams.png' }
      it { is_expected.to eq '/spree/products/1/large/hams.png' }
    end

    context "when the product doesn't have images" do
      it { is_expected.to be_nil }
    end
  end

  describe "#description" do
    subject { feed_product.description }
    it { is_expected.to eq "As seen on TV!" }
  end

  describe "#title" do
    subject { feed_product.title }
    it { is_expected.to eq "2 Hams 20 Dollars" }
  end
end

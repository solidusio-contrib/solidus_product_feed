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

    it "delegates to the product's SKU" do
      expect(subject).to eq product.id
    end
  end

  describe "#condition" do
    subject { feed_product.condition }
    it { is_expected.to eq "retail" }
  end

  describe "#price" do
    subject { feed_product.price }
    it { is_expected.to eq "19.99" }
  end

  describe "#image_link" do
    subject { feed_product.image_link }
    context "when the product has images" do
      before { create :image, viewable: product.master }
      it { is_expected.to match %r(/spree/products/1/large/thinking-cat.jpg\?\d{10}) }
    end

    context "when the product doesn't have images" do
      it { is_expected.to be_nil }
    end
  end

  describe "#published_at" do
    subject { feed_product.published_at }
    before { product.update_column :available_on, DateTime.new(0) }
    it { is_expected.to eq "Thu, 01 Jan 0000 00:00:00 +0000" }
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

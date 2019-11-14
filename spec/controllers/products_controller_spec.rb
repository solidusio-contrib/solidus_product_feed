# frozen_string_literal: true

require 'spec_helper'

describe Spree::ProductsController, type: :controller do
  render_views

  context "GET #index" do
    subject { get :index, params: { format: 'rss' } }

    let!(:product) { create :product, name: "2 Hams", price: 20.00 }

    it { is_expected.to have_http_status :ok }

    it { is_expected.to render_template 'spree/products/index' }

    it 'returns the correct content type' do
      subject
      expect(response.content_type.split(';').first).to eq 'application/rss+xml'
    end
  end

  context 'GET #index with weirdo formats' do
    subject { get :index, params: { format: 'wat' } }

    let!(:product) { create :product, name: "2 Hams", price: 20.00 }

    it "raises ActionController::UnkownFormat" do
      expect { subject }.to raise_exception(ActionController::UnknownFormat)
    end
  end
end

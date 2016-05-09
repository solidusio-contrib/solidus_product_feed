require 'spec_helper'

describe Spree::ProductsController, type: :controller do
  context "GET #index" do
    subject { get :index, format: 'rss', use_route: :spree}

    it { is_expected.to have_http_status :ok }

    it { is_expected.to render_template 'spree/products/index' }

    it 'returns the correct content type' do
      subject
      expect(response.content_type).to eq 'application/rss+xml'
    end
  end
end

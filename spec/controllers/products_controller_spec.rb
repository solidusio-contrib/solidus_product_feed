require 'spec_helper'

describe Spree::ProductsController, type: :controller do
  context "GET /index.rss" do
    before { get :index, format: 'rss', use_route: :spree}

    it 'succeeds' do
      expect(response).to be_success
    end

    it 'returns the correct content type' do
      expect(response.content_type).to eql('application/rss+xml')
    end
  end
end

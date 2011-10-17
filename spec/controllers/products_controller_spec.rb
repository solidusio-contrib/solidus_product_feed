require 'spec_helper'

describe ProductsController do
  context "GET /index" do
    before { get :index, :format => 'rss' }

    specify { response.should be_success }
    specify { response.content_type.should == 'application/rss+xml' }
  end
end

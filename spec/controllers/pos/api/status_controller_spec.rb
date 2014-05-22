require 'spec_helper'

describe Pos::Api::StatusController do
  let(:admin_user) { create(:admin_user) }

  describe "GET show" do
    after do
      response.should have_proper_api_headers
    end

    it "returns the last orders" do
      xhr :get, :show, api_token: admin_user.api_token

      response.header["Endpoint-Purpose"].should == "point_of_sale"
      response.body.should == "ok"
    end
  end
end

require 'spec_helper'

describe Pos::Api::StatusController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET show" do
    it "returns the last orders" do
      xhr :get, :show

      response.header["Endpoint-Purpose"].should == "point_of_sale"
      response.body.should == "ok"
    end
  end
end

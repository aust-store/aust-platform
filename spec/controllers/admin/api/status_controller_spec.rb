require 'spec_helper'

describe Admin::Api::StatusController do
  login_admin

  describe "GET show" do
    it "returns the last orders" do
      xhr :get, :show

      response.header["Endpoint-Purpose"].should == "admin"
      response.body.should == "ok"
    end
  end
end

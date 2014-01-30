require 'spec_helper'

describe Admin::Api::StatusController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET show" do
    it "returns the last orders" do
      xhr :get, :show

      response.body.should == "1"
    end
  end
end

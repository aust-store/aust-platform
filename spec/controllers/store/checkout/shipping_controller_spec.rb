require 'spec_helper'

describe Store::Checkout::ShippingController do
  describe "GET show" do
    it "redirects to the sign in page" do
      get :show
      response.should redirect_to "/users/sign_in"
    end
  end
end

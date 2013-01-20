require 'spec_helper'

describe Store::Checkout::ShippingController do
  it_should_behave_like "authenticable controller"
  it_should_behave_like "loading taxonomy"

  login_user

  let(:cart) { double.as_null_object }

  before do
    controller.stub(:cart) { cart }
    controller.stub(:current_store) { double.as_null_object }
  end

  describe "GET show" do
    it "instantiates the cart model" do
      cart.stub(:persistence) { :persistence }
      get :show
      assigns(:cart).should == :persistence
    end
  end

  describe "PUT update" do
    it "sets the cart's shipping address" do
      cart.should_receive(:set_shipping_address)
      put :update
    end

    it "redirects to the payments controller" do
      put :update
      response.should redirect_to checkout_payment_url
    end
  end
end

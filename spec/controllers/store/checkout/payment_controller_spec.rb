require 'spec_helper'

describe Store::Checkout::PaymentController do
  it_should_behave_like "authenticable controller"

  login_user

  let(:cart)     { double.as_null_object }
  let(:checkout) { double.as_null_object }

  before do
    controller.stub(:cart) { cart }
  end

  describe "GET show" do
    it "redirects to the payment gateway" do
      Store::Payment::Pagseguro::Checkout.stub(:new).with(controller, cart) { checkout }
      checkout.should_receive(:create_transaction)
      checkout.stub(:payment_url) { "http://payment_url" }
      get :show
      response.should redirect_to "http://payment_url"
    end
  end

  describe "#return_urls" do
    it "returns the correct return url for each gateway" do
      controller.return_urls[:pagseguro].should == gateway_notifications_pagseguro_url
    end
  end
end

require 'spec_helper'

describe Store::Checkout::PaymentController do
  it_should_behave_like "authenticable controller"

  login_user

  let(:cart)     { double.as_null_object }
  let(:checkout) { double(payment_url: 'http://payment_url').as_null_object }

  before do
    controller.stub(:cart) { cart }
    Store::Payment::Pagseguro::Checkout.stub(:new).with(controller, cart) { checkout }
  end

  describe "GET show" do
    it "redirects to the payment gateway" do
      checkout.should_receive(:create_transaction)
      get :show
      response.should redirect_to "http://payment_url"
    end

    it "converts the current cart into an order" do
      cart.should_receive(:convert_into_order)
      get :show
    end
  end

  describe "#after_payment_return_url" do
    it "returns the correct return url for each gateway" do
      controller.after_payment_return_url(:pagseguro).should == checkout_success_url
    end
  end
end

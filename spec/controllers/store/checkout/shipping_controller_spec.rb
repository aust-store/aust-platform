require 'spec_helper'

describe Store::Checkout::ShippingController do
  it_should_behave_like "authenticable controller"
  it_should_behave_like "loading taxonomy"

  login_user

  let(:cart) { double.as_null_object }

  before do
    controller.stub(:cart) { cart }
    controller.stub(:current_customer) { :current_customer }
    controller.stub(:current_store) { double.as_null_object }
  end

  describe "GET show" do
    let(:cart_model) { double }

    it "instantiates the cart model" do
      cart.stub(:persistence) { cart_model }
      cart_model.should_receive(:set_customer).with(:current_customer)
      cart_model.should_receive(:build_shipping_address)
      cart_model.stub_chain(:customer, :default_address) { :default_address }
      cart_model.stub(:zipcode_mismatch?) { :zipcode_mismatch }
      get :show
      assigns(:cart).should == cart_model
      assigns(:zipcode_mismatch).should == :zipcode_mismatch
      assigns(:customer_address).should == :default_address
    end
  end

  describe "PUT update" do
    let(:cart_model) { double }

    before do
      cart.stub(:persistence) { cart_model }
    end

    context "placing order with custom shipping address" do
      it "redirects to the payment url if cart is updated" do
        cart_model.stub(:update_attributes).with("key" => "value") { true }
        put :update, place_order_with_custom_shipping_address: "1", cart: {key: :value}
        response.should redirect_to checkout_payment_url
      end

      it "renders the show view unless cart is updated" do
        cart_model.stub(:update_attributes).with("key" => "value") { false }
        cart_model.should_receive(:build_shipping_address)
        cart_model.stub_chain(:customer, :default_address) { :customer_address }
        put :update, place_order_with_custom_shipping_address: "1", cart: {key: :value}
        response.should render_template :show
      end
    end

    context "placing order with default customer address" do
      let(:cart_address) { double }

      before do
        Store::Cart::AddressDefinition
          .stub(:new)
          .with(controller, cart_model)
          .and_return(cart_address)
      end

      it "sets the cart's shipping address" do
        cart_address.should_receive(:use_customers_default_address)
        put :update
      end

      it "redirects to the payments controller" do
        cart_address.stub(:use_customers_default_address)
        put :update
        response.should redirect_to checkout_payment_url
      end
    end
  end
end

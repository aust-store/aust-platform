require "spec_helper"

describe Store::CartController do
  it_should_behave_like "loading taxonomy"

  let(:store) { double.as_null_object }
  let(:cart) { double(id: 1, current_items: :items, persistence: :persistence).as_null_object }

  before do
    # TODO contract test - does cart has #items?
    controller.stub(:cart) { cart }
    controller.stub(:current_store) { store }
  end

  describe "GET show" do
    let(:checkout_policy) { double.as_null_object }

    before do
      Store::Policy::Checkout.stub(:new).with(controller) { checkout_policy }
    end

    it "loads the cart items" do
      get :show
      assigns(:cart_items).should == :items
    end

    it "decorates the cart" do
      DecorationBuilder.stub(:cart).with(:persistence) { :decorated_items }
      get :show
      assigns(:cart).should == :decorated_items
    end

    it "defines if the checkout is enabled" do
      checkout_policy.stub(:enabled?) { :checkout_enabled }
      get :show
      assigns(:checkout_enabled).should == :checkout_enabled
    end

    describe "sets the shipping calculation status" do
      it "has true value if the shipping calculation is enabled" do
        store.stub(:has_zipcode?) { true }
        get :show, store_id: "store_name"
        assigns(:shipping_calculation_enabled).should == true
      end

      it "has false value if the shipping calculation is enabled" do
        store.stub(:has_zipcode?) { false }
        get :show, store_id: "store_name"
        assigns(:shipping_calculation_enabled).should == false
      end
    end
  end

  describe "PUT update" do
    before do
      Store::Cart.stub(:new) { cart }
      Store::CartShippingCalculation.stub(:create)
    end

    it "updates the cart" do
      cart.should_receive(:update).with("cart_params")
      Store::CartShippingCalculation.should_receive(:create)
      put :update, store_id: "store_name", cart: "cart_params"
    end

    it "redirects the user to the show page" do
      cart.stub(:update)
      put :update, store_id: "store_name", cart: "true"
      response.should redirect_to cart_url
    end
  end
end

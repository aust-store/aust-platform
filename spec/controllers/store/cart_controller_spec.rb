require "spec_helper"

describe Store::CartController do
  it_obeys_the "cart contract"

  let(:cart) { double(id: 1, current_items: :items, persistence: :persistence) }

  before do
    # TODO contract test - does cart has #items?
    controller.stub(:cart) { cart }
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
  end

  describe "PUT update" do
    before do
      Store::Cart.stub(:new) { cart }
    end

    it "updates the cart" do
      cart.should_receive(:update).with("cart_params")
      put :update, store_id: "store_name", cart: "cart_params"
    end

    it "redirects the user to the show page" do
      cart.stub(:update)
      put :update, store_id: "store_name", cart: "true"
      response.should redirect_to cart_url
    end
  end
end

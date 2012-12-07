require "spec_helper"

describe Store::CartController do
  it_obeys_the "cart contract"

  let(:cart) { double(id: 1, current_items: :items, persistence: :persistence) }

  before do
    # TODO contract test - does cart has #items?
    controller.stub(:cart) { cart }
  end

  describe "GET show" do
    it "loads the cart items" do
      get :show, store_id: "store_name"
      assigns(:cart_items).should == :items
    end

    it "decorates the cart" do
      DecorationBuilder.stub(:cart).with(:persistence) { :decorated_items }
      get :show, store_id: "store_name"
      assigns(:cart).should == :decorated_items
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
      response.should redirect_to store_cart_url
    end
  end
end

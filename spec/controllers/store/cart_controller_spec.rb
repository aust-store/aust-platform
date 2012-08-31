require "spec_helper"

describe Store::CartController do
  describe "GET show" do
    it "loads the cart items" do
      # TODO contract test - does cart has #items?
      cart = double(id: 1, items: :items)
      Store::Cart.stub(:new) { cart }

      get :show, store_id: "store_name"
      assigns(:cart_items).should == :items
    end
  end
end

require "spec_helper"

describe Store::CartItemsController do
  it_obeys_the "items for sale contract"
  it_obeys_the "cart contract"

  describe "POST create" do
    let(:cart) { double(id: nil).as_null_object }
    let(:items_for_sale) { double(item_for_cart: :item) }
    let(:company) { double }

    before do
      Company.stub(:find_by_handle).with("store_name") { company }
      Store::Cart.stub(:new) { cart }
      Store::ItemsForSale.stub(:new) { items_for_sale }
    end

    it "adds an item to the cart" do
      cart.should_receive(:add_item).with(:item)
      post :create, store_id: "store_name", id: 2
    end

    it "redirects to the cart" do
      post :create, store_id: "store_name", id: 2
      response.should redirect_to store_cart_path(company)
    end
  end
end


require 'spec_helper'

describe Store::Cart::ShippingCostController do
  it_obeys_the "cart contract"

  describe "POST create" do
    let(:shipping_box) { double }
    let(:item) { double(shipping_box: shipping_box) }

    before do
      @items = [ double(inventory_item: item, quantity: 1),
                 double(inventory_item: item, quantity: 1) ]
      controller.stub_chain(:cart, :persistence, :items) { @items }
      controller.stub_chain(:cart, :total_unique_items) { :quantity }
    end

    it "responds to items" do
      Store::CartShippingCalculation.stub(:create) { double.as_null_object }
      post :create, store_id: "my_store", zipcode: "123456", type: :pac
      controller.cart_items_dimensions.should == [ shipping_box, shipping_box ]
    end
  end
end

require "unit_spec_helper"
require "store/cart/items_list"

describe Store::Cart::ItemsList do
  it_obeys_the "cart contract"
  it_obeys_the "cart items list contract"

  describe "#list" do
    let(:items) do
      [ double(inventory_entry_id: 1, quantity: 1.1),
        double(inventory_entry_id: 2, quantity: 3),
        double(inventory_entry_id: 3, quantity: 2.2) ]
    end

    let(:cart) { double(all_items: items) }

    it "instantiate items setting the quantity where appropriate" do
      list = Store::Cart::ItemsList.new(cart).list

      list[0].quantity.should == 1.1
      list[1].quantity.should == 3
      list[2].quantity.should == 2.2
    end
  end
end

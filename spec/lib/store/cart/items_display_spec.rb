require "unit_spec_helper"
require "store/cart/items_display"

describe Store::Cart::ItemsDisplay do
  describe "#list" do
    let(:items) do
      [ double(inventory_entry_id: 1, price: 1.1),
        double(inventory_entry_id: 1, price: 1.1),
        double(inventory_entry_id: 1, price: 2.2),
        double(inventory_entry_id: 2, price: 2.2) ]
    end

    let(:cart) { double(all_items: items) }

    it "instantiate items setting the quantity where appropriate" do
      list = Store::Cart::ItemsDisplay.new(cart).list

      list[0].quantity.should == 2
      list[1].quantity.should == 1
      list[2].quantity.should == 1
    end
  end
end

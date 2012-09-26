require "spec_helper"

describe Cart do
  describe "#add_item" do
    let(:cart) { Cart.new }

    it "adds the given item into the cart" do
      entry = double(price: 1, quantity: 2, good: :good)
      InventoryEntry.stub(:find).with(:entry_id) { entry }

      OrderItem.should_receive(:new)
               .with(price: 1,
                     quantity: 2,
                     inventory_entry: entry,
                     inventory_item: :good)
               .and_return(:new_item)

      items = double
      cart.stub(:items) { items }
      cart.stub(:save)
      items.should_receive(:<<).with(:new_item)
      cart.add_item(:entry_id, 2)
    end
  end
end

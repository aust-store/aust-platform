require "integration_spec_helper"

describe Cart do

  describe "#add_item" do
    let(:cart) { Cart.new }

    it "adds the given item into the cart" do
      entry = double(price: 1, quantity: 2, good: :good)
      InventoryEntry.stub(:find).with(1) { entry }

      cart.stub(:save)

      OrderItem.stub(:new)
               .with(price: 1,
                     quantity: 2,
                     inventory_entry: entry,
                     inventory_item: :good)
               .and_return(:new_item)

      cart.items.should_receive(:<<).with(:new_item)
      cart.add_item(1, 1)
    end
  end
end

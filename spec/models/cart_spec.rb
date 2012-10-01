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

  describe ".find_or_create_cart" do
    let(:cart) { double(id: :id, current_company: :company) }

    it "finds an existing persisted cart" do
      Cart.stub(:find).with(:id) { :found_persisted_cart }
      Cart.find_or_create_cart(cart).should == :found_persisted_cart
    end

    it "creates a new cart if no cart is previously found" do
      Cart.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      Cart.stub(:create).with(company: :company) { :created_new_cart }

      Cart.find_or_create_cart(cart).should == :created_new_cart
    end
  end
end

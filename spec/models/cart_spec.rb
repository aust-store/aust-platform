require "spec_helper"

describe Cart do
  describe "#add_item" do
    let(:cart) { Cart.new }
    let(:entry) { double(quantity: 5) }

    before do
      cart.stub(:current_inventory_entry).with(1) { entry }
    end

    it "increases the quantity of already existing cart items" do
      cart.stub(:item_already_in_cart).with(entry) { true }
      cart.should_receive(:increase_item_quantity).with(true, 2)
      cart.add_item(1, 2)
    end

    it "adds the given item into the cart if it doesn't exist yet" do
      cart.stub(:item_already_in_cart).with(entry) { false }
      cart.should_receive(:create_item_into_cart).with(entry)
      cart.add_item(1, 2)
    end

    it "raises exception if item is out of stock" do
      cart.stub(:current_inventory_entry).with(1) { double(quantity: 0) }
      expect do
        cart.add_item(1)
      end.to raise_error InventoryEntry::OutOfStock
    end
  end

  describe "#create_item_into_cart" do
    let(:cart) { Cart.new }

    it "creates the given item into the cart" do
      entry = double(price: 1, good: :good)

      OrderItem.should_receive(:new)
               .with(price: 1,
                     quantity: 1,
                     inventory_entry: entry,
                     inventory_item: :good)
               .and_return(:new_item)


      items = double
      cart.stub(:items) { items }
      items.should_receive(:<<).with(:new_item)
      cart.should_receive(:save)

      cart.create_item_into_cart(entry)
    end
  end

  describe "#current_inventory_entry" do
    it "returns the current inventory_entry" do
      cart = Cart.new
      cart.stub_chain(:company, :inventory_entries, :find).with(2) { :entry }
      cart.current_inventory_entry(2).should == :entry
    end
  end

  describe "#item_already_in_cart" do
    let(:cart)  { Cart.new }
    let(:entry) { double(price: 10) }
    let(:items) { double }
    
    before do
      cart.stub(:items) { items }
    end

    it "returns true if item already exists in the cart with same price" do
      cart.items.stub(:where).with("price = ?", 10) { double(first: :item) }
      cart.item_already_in_cart(entry).should == :item
    end

    it "returns false if item is not in the cart" do
      cart.items.stub(:where).with("price = ?", 10) { double(first: []) }
      cart.item_already_in_cart(entry).should == []
    end
  end

  describe "#increase_item_quantity" do
    let(:item) { double(quantity: 5) }

    it "updates an item's quantity attribute" do

      cart = Cart.new
      cart.stub(:update_item_quantity).with(item, 6) { :updated_item }
      cart.increase_item_quantity(item, 1).should == :updated_item
    end
  end

  describe "#update_item_quantity" do
    let(:item)  { double(remaining_entries_in_stock: 10) }

    it "updates an item's quantity attribute" do
      item.should_receive(:update_quantity).with(5)

      cart = Cart.new
      cart.update_item_quantity(item, 5)
    end

    it "doesn't update an item's quantity attribute if nil was given" do
      item.should_not_receive(:update_quantity)

      cart = Cart.new
      cart.update_item_quantity(item, nil)
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

  describe "#update_quantities_in_batch" do
    let(:params) { { "10" => "3", "11" => "5" } }
    let(:item_one)   { double(id: 9) }
    let(:item_two)   { double(id: 10) }
    let(:item_three) { double(id: 11) }
    let(:items) { [ item_one, item_two, item_three ] }

    it "iterates over each item needing change and asks for update" do
      cart = Cart.new
      cart.stub(:items) { items }

      item_one.should_not_receive(:update_quantity)
      item_two    .should_receive(:update_quantity).with(3)
      item_three  .should_receive(:update_quantity).with(5)

      cart.update_quantities_in_batch(params)
    end
  end
end

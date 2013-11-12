require "spec_helper"

describe Cart do
  subject { Cart.new }

  describe "#total" do
    it "returns the result of a price calculation" do
      cart = Cart.new
      Store::Order::PriceCalculation.stub(:calculate).with(:items) { :total }
      cart.stub_chain(:items) { :items }
      expect(cart.total).to eq :total
    end
  end

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

  describe "#update_shipping" do
    let(:shipping) { double }
    let(:build_shipping) { double }

    it "updates the customer of the cart" do
      build_shipping.should_receive(:create_for_cart).with(shipping) { :persisted }
      cart = Cart.new
      cart.stub(:shipping) { shipping }
      shipping.should_receive(:destroy)
      cart.stub(:build_shipping) { build_shipping }
      cart.should_receive(:shipping=).with(:persisted)

      cart.update_shipping(shipping)
    end
  end

  describe "#set_customer" do
    let(:customer) { double }

    it "updates the customer of the cart" do
      cart = Cart.new
      cart.should_receive(:update_attributes).with(customer: customer)
      cart.set_customer(customer)
    end
  end

  describe "#current_inventory_entry" do
    it "returns the current inventory_entry" do
      cart = Cart.new
      cart.stub_chain(:company, :inventory_entries, :find).with(2) { :entry }
      cart.current_inventory_entry(2).should == :entry
    end
  end

  describe ".find_or_create_cart" do
    let(:company) { double(carts: carts) }
    let(:cart) { double(id: :id, current_company: company) }
    let(:carts) { double }

    it "finds an existing persisted cart" do
      carts.stub(:find).with(:id) { :found_persisted_cart }
      Cart.find_or_create_cart(cart).should == :found_persisted_cart
    end

    it "creates a new cart if no cart is previously found" do
      carts.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      carts.stub(:create) { :created_new_cart }

      Cart.find_or_create_cart(cart).should == :created_new_cart
    end
  end

  describe "#reset_shipping" do
    it "destroy the cart's shipping calculations" do
      cart = Cart.new
      shipping = double
      cart.stub(:shipping) { shipping }
      shipping.should_receive(:destroy)
      cart.reset_shipping
    end
  end

  describe "#convert_into_order" do
    it "creates an order based on the cart" do
      cart = FactoryGirl.create(:offline_cart)
      returned_value = cart.convert_into_order
      order = Order.where(cart_id: cart.id).first

      # order counterpart should be created
      order.should be_present
      order.should == returned_value

      # order attributes should match the cart's
      order.environment.should == "offline"
      order.cart_id    .should == cart.id
      order.customer_id.should == cart.customer_id
      order.store      .should == cart.company

      # cart items are copied as well
      cart.items.each do |item|
        order.items.should include item
      end

      # shipping address is copied as well
      order.shipping_address.should == cart.shipping_address

      # shipping options are copied as well
      order.shipping_details.should == cart.shipping
    end
  end

  describe "#items_shipping_boxes" do
    let(:shipping_box1) { double }
    let(:shipping_box2) { double }
    let(:item1) { double(quantity: 1, shipping_box: shipping_box1) }
    let(:item2) { double(quantity: 2, shipping_box: shipping_box2) }

    it "returns all the shipping boxes for transport cost calculation" do
      cart = Cart.new
      cart.stub(:items) { [item1, item2] }
      cart.items_shipping_boxes.should == [shipping_box1, shipping_box2, shipping_box2]
    end
  end

  describe "#zipcode_mismatch?" do
    before { subject.stub(:shipping) { double(zipcode: 1) } }

    context "no shipping details exist" do
      it "returns true if the zipcode wasn't yet defined" do
        subject.stub_chain(:customer, :default_address, :zipcode) { 1 }
        subject.stub(:shipping) { nil } # no zipcode exists at all
        subject.zipcode_mismatch?.should be_true
      end
    end

    context "shipping address is absent" do
      before { subject.stub(:shipping_address) { nil } }

      it "returns false if the customer's zipcode matches the cart's" do
        subject.stub_chain(:customer, :default_address, :zipcode) { 1 }
        subject.zipcode_mismatch?.should be_false
      end

      it "returns true if the customer's zipcode doesn't match the cart's" do
        subject.stub_chain(:customer, :default_address, :zipcode) { 2 }
        subject.zipcode_mismatch?.should be_true
      end
    end

    context "shipping address is present" do
      it "returns false if the shipping address' zipcode matches the cart's" do
        subject.stub(:shipping_address) { double(zipcode: 1) }
        subject.zipcode_mismatch?.should be_false
      end

      it "returns true if the shipping address' zipcode doesn't match the cart's" do
        subject.stub(:shipping_address) { double(zipcode: 2) }
        subject.zipcode_mismatch?.should be_true
      end
    end
  end
end

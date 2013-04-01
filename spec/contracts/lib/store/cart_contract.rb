require "store/cart"

shared_examples "cart contract" do
  describe "Cart" do
    let(:controller) { double.as_null_object }
    let(:cart) { Store::Cart.new(controller) }

    before do
      Store::Cart.any_instance.stub(:persisted_cart)
      Store::Cart.any_instance.stub(:persistence) { double.as_null_object }
    end

    it "responds to add_item" do
      expect do
        cart.add_item(double)
      end.to_not raise_error NoMethodError
    end

    it "responds to remove_item" do
      expect do
        cart.remove_item(double)
      end.to_not raise_error NoMethodError
    end

    it "responds to parent_items" do
      expect do
        cart.parent_items
      end.to_not raise_error NoMethodError
    end

    it "responds to current_company" do
      expect do
        cart.current_company
      end.to_not raise_error NoMethodError
    end

    it "responds to persisted_cart" do
      expect do
        cart.persisted_cart
      end.to_not raise_error NoMethodError
    end

    it "responds to update" do
      expect do
        cart.update(double)
      end.to_not raise_error NoMethodError
    end

    it "responds to set_shipping_address" do
      expect do
        cart.set_shipping_address
      end.to_not raise_error NoMethodError
    end
  end
end

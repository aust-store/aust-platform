require "store/cart"

shared_examples "cart contract" do
  describe "Cart" do
    before do
      Store::Cart.any_instance.stub(:persist_cart)
    end

    it "responds to add_item" do
      cart = Store::Cart.new(double, double)
      cart.stub(:persistence) { double.as_null_object }
      expect do
        cart.add_item(double)
      end.to_not raise_error NoMethodError
    end

    it "responds to all_items" do
      cart = Store::Cart.new(double, double)
      cart.stub_chain(:persistence, :items, :all) { double.as_null_object }
      expect do
        cart.all_items
      end.to_not raise_error NoMethodError
    end
  end
end

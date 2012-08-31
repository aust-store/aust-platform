require "store/cart"

shared_examples "cart contract" do
  describe "Cart" do
    it "responds to add_item" do
      Store::Cart.any_instance.stub(:persist_cart)
      cart = Store::Cart.new(double, double)
      cart.stub(:persistence) { double.as_null_object }
      expect do
        cart.add_item(double)
      end.to_not raise_error NoMethodError
    end
  end
end

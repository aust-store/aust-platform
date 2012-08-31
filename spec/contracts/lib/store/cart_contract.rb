require "store/cart"

shared_examples "cart contract" do
  describe "Cart" do
    it "responds to add_item" do
      expect do
        Store::Cart.new(double, double).add_item(double)
      end.to_not raise_error NoMethodError
    end
  end
end

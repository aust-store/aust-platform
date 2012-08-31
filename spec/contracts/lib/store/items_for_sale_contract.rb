require "store/items_for_sale"

shared_examples "items for sale contract" do
  describe "ItemsForSale" do
    it "responds to item_for_cart" do
      expect do
        Store::ItemsForSale.new(double).item_for_cart
      end.to_not raise_error NoMethodError
    end
  end
end

require "store/items_for_website_sale"

shared_examples "items for sale contract" do
  describe "ItemsForWebsiteSale" do
    it "responds to item_for_cart" do
      expect do
        Store::ItemsForWebsiteSale.new(double).item_for_cart
      end.to_not raise_error NoMethodError
    end
  end
end

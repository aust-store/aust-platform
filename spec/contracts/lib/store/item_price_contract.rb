require "store/item_price"

shared_examples "item price contract" do
  describe "ItemPrice" do
    it "responds to price" do
      price = Store::ItemPrice.new(double)
      price.stub(:entry_for_sale) { double(price: 1) }
      expect do
        price.price
      end.to_not raise_error NoMethodError
    end

    it "responds to entry_for_sale" do
      price = Store::ItemPrice.new(double)
      price.stub(:fetch_entry_for_sale)
      expect do
        price.entry_for_sale
      end.to_not raise_error NoMethodError
    end
  end
end

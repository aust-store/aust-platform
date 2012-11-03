require "contracts/lib/store/item_price_contract"
require "store/item_price"

describe Store::ItemPrice do
  it_behaves_like "item price contract"

  let(:item) { double }

  describe "#price" do
    it "returns the first entry's price" do
      item_price = Store::ItemPrice.new(item)
      item_price.stub(:entry_for_sale) { double(price: 10) }
      expect(item_price.price).to eql(10)
    end
  end

  describe "#entry_for_sale" do
    it "returns the item's first inventory entry" do
      item.stub(:entry_for_sale) { :first }

      item_price = Store::ItemPrice.new(item)
      expect(item_price.entry_for_sale).to eql(:first)
    end
  end
end

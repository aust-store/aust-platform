require "store/order/items/out_of_stock_adjustment"

describe Store::Order::Items::OutOfStockAdjustment do
  let(:cart)   { double(items: items) }
  let(:item1)  { double(quantity: 4, inventory_entry: entry1) }
  let(:item2)  { double(quantity: 3, inventory_entry: entry2) }
  let(:items)  { double(parent_items: [item1, item2]) }
  let(:entry1) { double(quantity: 2) }
  let(:entry2) { double(quantity: 5) }

  subject { described_class.new(cart) }

  describe "#adjust" do
    it "adjusts item1's quantity to comply with the stock" do
      item1.should_receive(:update_quantity).with(2)
      item2.should_not_receive(:update_quantity)

      subject.adjust
    end
  end
end

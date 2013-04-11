require "store/stock/decrement_after_order"

describe Store::Stock::DecrementAfterOrder do
  let(:order) { double(items: items) }
  let(:item1) { double(inventory_entry_id: 2) }
  let(:item2) { double(inventory_entry_id: 4) }
  let(:item3) { double(inventory_entry_id: 4) }
  let(:items) { [item1, item2, item3] }
  let(:entry1) { double(quantity: 5) }
  let(:entry2) { double(quantity: 3) }

  subject { described_class.new(order) }

  before do
    stub_const("InventoryEntry", Class.new)
  end

  describe "#subtract" do
    before do
      InventoryEntry.stub(:find).with(2) { entry1 }
      InventoryEntry.stub(:find).with(4) { entry2 }
    end

    it "subtracts the entries quantity" do
      entry1.should_receive(:update_attributes).with(quantity: 4).once
      entry2.should_receive(:update_attributes).with(quantity: 1).once
      subject.subtract
    end
  end
end

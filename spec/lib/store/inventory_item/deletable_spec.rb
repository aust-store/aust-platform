require "store/inventory_item/deletable"
require "active_support/core_ext/object"

describe Store::InventoryItem::Deletable do
  let(:item) { double(order_items: []) }

  subject { described_class.new(item) }

  describe "#valid?" do
    context "when it's deletable" do
      it "returns true" do
        subject.should be_valid
      end
    end

    context "when it's associated to an order item" do
      before do
        item.stub(order_items: [true])
      end

      it "returns false" do
        subject.should_not be_valid
      end
    end
  end
end

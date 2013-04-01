require "persistence/order_item_quantity"

describe Persistence::OrderItemQuantity do
  let(:item) { double(quantity: 10) }

  subject { described_class.new(item) }

  before do
    item.stub(:inventory_entry) { double(quantity: 15) }
  end

  describe "#change" do
    describe "sanitizing the quantity" do
      before do
        subject.stub(:create_children)
        subject.stub(:destroy_exceeding_children)
      end

      it "doesn't allow quantity greater than available in stock" do
        subject.should_receive(:create_children).with(15)
        subject.change(25.0)
      end

      it "doesn't allow quantity lesser than 0" do
        subject.should_receive(:destroy_exceeding_children).with(0)
        subject.change(-5.0)
      end
    end
  end
end

require "store/sale"

describe Store::Sale do
  let(:cart) { double }

  subject { described_class.new(cart, {}) }

  before do
    stub_const("Store::Order::CreationFromCart", Class.new)
    stub_const("Store::Stock::DecrementAfterOrder", Class.new)
    stub_const("Order", Class.new)
    stub_const("InventoryItem", Class.new)
  end

  describe "#close" do
    it "creates a new order from the cart" do
      subject.stub(:subtract_items_from_stock)

      order_creation = double
      Store::Order::CreationFromCart.stub(:new).with(cart, {}) { order_creation }
      order_creation.should_receive(:convert_cart_into_order)

      subject.close
    end

    it "subtract the order items from the stock" do
      Store::Order::CreationFromCart.stub_chain(:new, :convert_cart_into_order) { :order }

      stock_subtraction = double
      Store::Stock::DecrementAfterOrder.stub(:new).with(:order) { stock_subtraction }
      stock_subtraction.should_receive(:subtract)

      subject.close
    end
  end
end

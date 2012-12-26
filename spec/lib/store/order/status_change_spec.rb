require "store/order/status_change"

describe Store::Order::StatusChange do
  let(:order)          { double }
  let(:payment_status) { double }
  let(:notification)   { double(id: 2, unique_id_within_gateway: 3) }

  subject { described_class.new(notification) }

  before do
    stub_const("Order", Class.new)
    stub_const("PaymentStatus", Class.new)
    Order.stub(:find).with(2) { order }
    PaymentStatus.stub(:new).with(notification_id: 3, order: order) { payment_status }
  end

  describe "#change" do
    context "gateway is processing the order" do
      it "sends a signal to the order to update itself accordingly" do
        notification.stub(:status) { :some_status }
        payment_status.should_receive(:set_status_as).with(:some_status)
        subject.change
      end
    end
  end

  describe ".change" do
    it "is an alias for .new().change" do
      described_class.any_instance.should_receive(:change)
      described_class.change(notification)
    end
  end
end

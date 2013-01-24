require 'spec_helper'

describe PaymentStatus do
  describe "#set_status_as" do
    it "sets to approved" do
      status = described_class.new(order_id: 1)
      status.set_status_as(:approved)
      saved_status = described_class.last
      saved_status.status.should == "approved"
    end
  end

  describe "#current_status" do
    it "returns the last status as a symbol" do
      described_class.stub(:last) { double(status: :approved) }
      expect(described_class.current_status).to eq :approved
    end

    it "returns nil if there's no status" do
      described_class.stub(:last) { nil }
      expect(described_class.current_status).to eq :undefined
    end
  end

  describe ".paid?" do
    it "returns true when status is approved" do
      PaymentStatus.stub(:current_status) { :approved }
      expect(PaymentStatus.paid?).to be_true
    end

    it "returns true when status is available_for_withdrawal" do
      PaymentStatus.stub(:current_status) { :approved }
      expect(PaymentStatus.paid?).to be_true
    end

    it "returns false when status is anything else" do
      PaymentStatus.stub(:current_status) { :refund }
      expect(PaymentStatus.paid?).to be_false
    end
  end

  describe ".cancelled?" do
    it "returns true when status is cancelled" do
      PaymentStatus.stub(:current_status) { :cancelled }
      expect(PaymentStatus.cancelled?).to be_true
    end

    it "returns true when status is refunded" do
      PaymentStatus.stub(:current_status) { :refunded }
      expect(PaymentStatus.cancelled?).to be_true
    end

    it "returns true when status is disputed" do
      PaymentStatus.stub(:current_status) { :disputed }
      expect(PaymentStatus.cancelled?).to be_true
    end

    it "returns false when status is anything else" do
      PaymentStatus.stub(:current_status) { :approved }
      expect(PaymentStatus.cancelled?).to be_false
    end
  end
end

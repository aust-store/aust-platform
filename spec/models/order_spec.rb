require 'spec_helper'

describe Order do
  it_should_behave_like "uuid", :order, :uuid

  describe "validations" do
    context "environment" do
      it { should allow_value(:offline).for(:environment)  }
      it { should allow_value(:website).for(:environment)  }
      it { should allow_value("offline").for(:environment)  }
      it { should allow_value("website").for(:environment)  }

      it { should_not allow_value(:online).for(:environment)  }
    end
  end

  describe "#current_payment_status" do
    it "returns the last status" do
      subject.stub_chain(:payment_statuses, :current_status) { :some_status }
      expect(subject.current_payment_status).to eq :some_status
    end
  end

  describe "#summary" do
    context "paid" do
      before do
        subject.stub_chain(:payment_statuses, :paid?) { true }
      end

      it "is paid and shipped" do
        subject.items << OrderItem.new(status: "shipped")
        subject.items << OrderItem.new(status: "cancelled")
        subject.save
        expect(subject.summary).to eq :paid_and_shipped
      end

      it "is paid but pending shipment" do
        subject.items << OrderItem.new(status: "pending")
        subject.items << OrderItem.new(status: "pending")
        subject.save
        expect(subject.summary).to eq :paid_pending_all_shipments
      end

      it "is paid but pending shipment from some items" do
        subject.items << OrderItem.new(status: "shipped")
        subject.items << OrderItem.new(status: "pending")
        subject.save
        expect(subject.summary).to eq :paid_some_shipped_some_pending
      end

      it "is paid but items were cancelled, missing refund" do
        subject.items << OrderItem.new(status: "cancelled")
        subject.items << OrderItem.new(status: "cancelled")
        subject.save
        expect(subject.summary).to eq :paid_but_shipment_cancelled
      end
    end

    it "is not pending because all items were cancelled" do
      subject.stub_chain(:payment_statuses, :paid?)  { false }
      subject.stub_chain(:payment_statuses, :cancelled?) { true }
      subject.items << OrderItem.new(status: "cancelled")
      subject.items << OrderItem.new(status: "cancelled")
      subject.save
      expect(subject.summary).to eq :cancelled
    end

    it "is pending payment" do
      subject.stub(:current_payment_status) { :undefined }
      subject.items << OrderItem.new(status: "pending")
      subject.items << OrderItem.new(status: "pending")
      subject.save
      expect(subject.summary).to eq :pending_payment
    end
  end

  describe "#create_offline" do
    it "adds a new environment key defining the order as made offline" do
      Order.should_receive(:create).with({field: 'value', environment: :offline})
      Order.create_offline(field: 'value')
    end
  end
end

require "store/gateway_notifications/base"
require "store/gateway_notifications/pagseguro_wrapper"
require "unit_spec_helper"

describe Store::GatewayNotifications::PagseguroWrapper do
  let(:notification) { double(processing?:  nil,
                              approved?:    nil,
                              in_analysis?: nil,
                              available?:   nil,
                              disputed?:    nil,
                              returned?:    nil,
                              cancelled?:   nil) }

  subject { Store::GatewayNotifications::PagseguroWrapper.new(notification) }

  it_should_behave_like "gateway notifications api"

  describe "#order_id" do
    it "wraps the gateway class interface" do
      notification.stub(:id) { :id }
      subject.order_id.should == :id
    end
  end

  describe "#unique_id_within_gateway" do
    it "wraps the gateway class interface" do
      notification.stub(:transaction_id) { :transaction_id }
      subject.unique_id_within_gateway.should == :transaction_id
    end
  end

  describe "#processing?" do
    it "wraps the gateway class interface" do
      notification.stub(:processing?) { true }
      subject.status.should == :processing
    end
  end

  describe "#in_analysis?" do
    it "wraps the gateway class interface" do
      notification.stub(:in_analysis?) { :in_analysis }
      subject.status.should == :in_analysis
    end
  end

  describe "#approved?" do
    it "wraps the gateway class interface" do
      notification.stub(:approved?) { :approved }
      subject.status.should == :approved
    end
  end

  describe "#available_for_withdrawal?" do
    it "wraps the gateway class interface" do
      notification.stub(:available?) { :available }
      subject.status.should == :available_for_withdrawal
    end
  end

  describe "#disputed?" do
    it "wraps the gateway class interface" do
      notification.stub(:disputed?) { :disputed }
      subject.status.should == :disputed
    end
  end

  describe "#refunded?" do
    it "wraps the gateway class interface" do
      notification.stub(:returned?) { :returned }
      subject.status.should == :refunded
    end
  end

  describe "#cancelled?" do
    it "wraps the gateway class interface" do
      notification.stub(:cancelled?) { :cancelled }
      subject.status.should == :cancelled
    end
  end
end

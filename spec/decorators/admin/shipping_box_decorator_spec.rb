require 'spec_helper'

describe Admin::ShippingBoxDecorator do
  it_obeys_the "Store Number contract"

  let(:item) { double(length: 1, width: 2, height: 3, weight: 4) }

  subject { Admin::ShippingBoxDecorator.new(item) }

  before do
    subject.stub(:item) { item }
  end

  describe "#length" do
    it "returns a number" do
      Store::Number.should_receive(:new).with(1) { double(remove_zeros: 10) }
      subject.length.should == "10cm"
    end
  end

  describe "#width" do
    it "returns a number" do
      Store::Number.should_receive(:new).with(2) { double(remove_zeros: 10) }
      subject.width.should == "10cm"
    end
  end

  describe "#height" do
    it "returns a number" do
      Store::Number.should_receive(:new).with(3) { double(remove_zeros: 10) }
      subject.height.should == "10cm"
    end
  end

  describe "#weight" do
    it "returns a number" do
      Store::Number.should_receive(:new).with(4) { double(remove_zeros: 10) }
      subject.weight.should == "10kg"
    end
  end
end

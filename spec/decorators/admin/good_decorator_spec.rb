require 'spec_helper'

describe Admin::GoodDecorator do
  let(:good) { double.as_null_object }
  subject { Admin::GoodDecorator.new(good) }

  before do
    subject.stub(:good) { good }
  end

  describe "#has_images?" do
    it "should return true if images are present" do
      good.stub_chain(:images, :present?) { true }
      subject.has_image?.should be_true
    end

    it "should return false if images aren't present" do
      good.stub_chain(:images, :present?) { false }
      subject.has_image?.should be_false
    end
  end

  describe "#total_quantity_summing_inventory_entries" do
    it "returns the total" do
      good.stub(:total_quantity) { "10" }
      subject.total_quantity_summing_inventory_entries.should == "10 un."
    end

    it "returns out of stock" do
      good.stub(:total_quantity) { "0" }
      subject.total_quantity_summing_inventory_entries.should == "fora do estoque"
    end
  end

  describe "#price" do
    it "converts price to currency" do
      good.stub(:price) { 2 }
      subject.stub(:to_currency).with(2) { "$2" }
      subject.price.should == "$2"
    end
  end
end

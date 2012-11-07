require 'spec_helper'

describe Admin::InventoryItemDecorator do
  let(:item) { double.as_null_object }
  subject { Admin::InventoryItemDecorator.new(item) }

  before do
    subject.stub(:item) { item }
  end

  describe "#has_images?" do
    it "should return true if images are present" do
      item.stub_chain(:images, :present?) { true }
      subject.has_image?.should be_true
    end

    it "should return false if images aren't present" do
      item.stub_chain(:images, :present?) { false }
      subject.has_image?.should be_false
    end
  end

  describe "#total_quantity_summing_inventory_entries" do
    it "returns the total" do
      item.stub(:total_quantity) { "10" }
      subject.total_quantity_summing_inventory_entries.should == "10 un."
    end

    it "returns out of stock" do
      item.stub(:total_quantity) { "0" }
      subject.total_quantity_summing_inventory_entries.should == "fora do estoque"
    end
  end

  describe "#price" do
    it "converts price to currency" do
      item.stub(:price) { 2 }
      subject.stub(:to_currency).with(2) { "$2" }
      subject.price.should == "$2"
    end
  end
end

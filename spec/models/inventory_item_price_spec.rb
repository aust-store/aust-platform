require "spec_helper"

describe InventoryItemPrice do
  subject { InventoryItemPrice.new }

  describe "validations" do
    describe "value" do
      it "doesn't accept an empty value" do
        build(:inventory_item_price, value: "0").should_not be_valid
      end

      it "doesn't accept an empty value" do
        build(:inventory_item_price, value: "").should_not be_valid
      end

      it "doesn't accept nil value" do
        build(:inventory_item_price, value: nil).should_not be_valid
      end
    end
  end

  describe "callbacks" do
    describe "#sanitize_currency before_validation" do
      it "removes the money symbols and converts the value to float" do
        price = described_class.new(value: "R$ 12,34")
        price.value.to_s.should == "12.34"
      end
    end
  end

  describe "#for_installments" do
    it "returns the regular price if none was defined" do
      subject.value = "15"
      subject.for_installments = "0"
      subject.for_installments.should == 15.0
    end
  end

  describe "#value=" do
    it "converts a string into float before setting it" do
      subject.value = "R$ 12,00"
      subject.value.should == 12.0
    end

    it "works with float as well" do
      subject.value = 12.0
      subject.value.should == 12.0
    end
  end

  describe "#for_installments=" do
    it "converts a string into float before setting it" do
      subject.for_installments = "R$ 12,00"
      subject.for_installments.should == 12.0
    end
  end
end

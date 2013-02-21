require "spec_helper"

describe InventoryItemPrice do
  describe "callbacks" do
    describe "#sanitize_currency before_validation" do
      it "removes the money symbols and converts the value to float" do
        price = described_class.new(value: "R$ 12,34")
        price.value.to_s.should == "12.34"
      end
    end
  end
end

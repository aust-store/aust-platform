# TODO unit test
require 'integration_spec_helper'

describe InventoryEntry do
  describe "#define_new_balance_values" do
    context "when first entry" do
      before do
        @resource = Factory.build(:inventory_entry_lite)
      end

      it "should have the correct values" do
        @resource.define_new_balance_values
        @resource.moving_average_cost.to_s.should == BigDecimal("20.0").to_s
        @resource.total_quantity.should == 4
        @resource.total_cost.to_s.should == BigDecimal("80.0").to_s
      end
    end

    context "when adding to existing balance" do
      before do
        Factory(:inventory_entry, good: @good, quantity: 10, cost_per_unit: 20)
        @resource = Factory.build(:inventory_entry_lite, good: @good, quantity: 10, cost_per_unit: 40)
      end

      it "should have the correct values" do
        @resource.define_new_balance_values
        @resource.moving_average_cost.to_s.should == BigDecimal("30.0").to_s
        @resource.total_quantity.should == 20
        @resource.total_cost.to_s.should == BigDecimal("600.0").to_s
      end
    end
  end
end

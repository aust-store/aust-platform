require 'spec_helper'

describe InventoryEntry do
  describe "callbacks" do
    describe "#define_new_balance_values" do
      context "when first entry" do
        before do
          @resource = FactoryGirl.build(:inventory_entry)
        end

        it "should have the correct values" do
          @resource.define_new_balance_values
          @resource.moving_average_cost.to_s.should == BigDecimal("20.0").to_s
          @resource.total_quantity.should == 8
          @resource.total_cost.to_s.should == BigDecimal("160.0").to_s
        end
      end

      context "when adding to existing balance" do
        before do
          FactoryGirl.create(:inventory_entry, inventory_item: nil,
                             quantity: 10, cost_per_unit: 20)
          @resource = FactoryGirl.build(:inventory_entry,
                                        inventory_item: nil,
                                        quantity: 10,
                                        cost_per_unit: 40)
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
end

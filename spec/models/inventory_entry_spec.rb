require 'spec_helper'

describe InventoryEntry do
  describe "callbacks" do
    describe "#define_new_balance_values on before_save" do
      context "when creating a new item with an embedded new entry" do
        before do
          @entry1 = FactoryGirl.attributes_for(:inventory_entry,
                                               quantity: 12, cost_per_unit: 20)
          @entry2 = FactoryGirl.attributes_for(:inventory_entry,
                                               quantity: 14, cost_per_unit: 40)
          @item = FactoryGirl.create(:inventory_item_without_associations,
                                     entries_attributes: [@entry1, @entry2])
          @item.reload
        end

        it "calculates the correct value" do
          @item.moving_average_cost.should == BigDecimal.new("30.77")
        end
      end

      context "when adding to existing balance" do
        before do
          @item = FactoryGirl.create(:inventory_item_without_associations)
        end

        it "should have the correct values" do
          create_entry(@item, 10, 40)
          @item.moving_average_cost.should == 40

          create_entry(@item, 12, 60)
          @item.moving_average_cost.to_s("F").should == "50.91"

          InventoryEntry.last.update_attributes(quantity: 7)

          @item.reload
          @item.moving_average_cost.to_s("F").should == "50.91"
        end
      end

      def create_entry(item, quantity, cost_per_unit)
        FactoryGirl.create(:inventory_entry, inventory_item: @item,
                           quantity: quantity, cost_per_unit: cost_per_unit)
        @item.reload
      end
    end
  end
end

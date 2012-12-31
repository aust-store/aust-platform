require 'spec_helper'

describe InventoryItem do
  describe "scopes" do
    describe "#with_entry_for_sale" do
      it "should return the correct entries" do
        FactoryGirl.create(:inventory_item)
        FactoryGirl.create(:inventory_item)
        FactoryGirl.create(:inventory_item)

        items = InventoryItem.first(2)
        items[0].balances.first.update_attribute(:on_sale, false)
        items[1].balances.first.update_attribute(:on_sale, false)

        result = InventoryItem.with_entry_for_sale.limit(2).order("inventory_items.id ASC")

        result[0].id.should == items.first.id
        result[0].balances.first.id.should == items[0].balances.second.id
        result[0].balances.first.on_sale.should == true

        result[1].id.should == items.second.id
        result[1].balances.first.id.should == items[1].balances.second.id
        result[1].balances.first.on_sale.should == true
      end
    end
  end

  describe "#search_for" do
    let(:search) { double(search: double(includes: :search)) }

    it "results the correct words by name" do
      Store::ItemsSearch.should_receive(:new).with(InventoryItem, :item) { search }

      InventoryItem.search_for(:item).should == :search
    end
  end

  describe "#price" do
    let(:item_price) { double }

    it "should delegate to ItemPrice" do
      item = InventoryItem.new
      Store::ItemPrice.stub(:new).with(item) { item_price }
      item_price.should_receive(:price)

      item.price
    end
  end

  describe "#entry_for_sale" do
    before do
      @item = FactoryGirl.create(:inventory_item)
    end

    it "loads the first entry for sale" do
      entries = @item.balances
      @item.entry_for_sale.should == entries.first
      InventoryEntry.first.update_attribute(:on_sale, false)
      @item.entry_for_sale.should == entries.second
    end
  end
end

require 'spec_helper'

describe InventoryItem do
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
      @item = FactoryGirl.create(:inventory_item_with_company)
    end

    it "loads the first entry for sale" do
      entries = @item.balances.all
      @item.entry_for_sale.should == entries.first
      InventoryEntry.first.update_attribute(:on_sale, false)
      @item.entry_for_sale.should == entries.last
    end
  end
end

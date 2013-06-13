require 'spec_helper'

describe InventoryItem do
  describe "scopes" do
    describe "#with_entry_for_sale" do
      it "should return the correct entries" do
        # each item has 3 entries
        FactoryGirl.create(:inventory_item)
        FactoryGirl.create(:inventory_item)
        FactoryGirl.create(:inventory_item)

        items = InventoryItem.order("id ASC").first(2)
        items[0].balances.first .update_attribute(:on_sale, false)
        items[0].balances.second.update_attribute(:on_sale, false)
        items[1].balances.first .update_attribute(:on_sale, false)
        items[1].balances.second.update_attribute(:on_sale, false)

        result = InventoryItem.with_entry_for_sale.limit(2).order("inventory_items.id ASC")
        result[0].entry_for_sale.id.should == items[0].balances.last.id
        result[1].entry_for_sale.id.should == items[1].balances.last.id
      end
    end
  end

  describe "#search_for" do
    it "searches for items" do
      item = FactoryGirl.create(:inventory_item, name: "my item")
      InventoryItem.search_for("item").to_a.should include item
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
      entries = @item.balances.order("id asc").all
      @item.entry_for_sale.should == entries.first
      InventoryEntry.first.update_attribute(:on_sale, false)
      @item.entry_for_sale.should == entries.second
    end
  end

  describe "#remove_empty_shipping_box" do
    before do
      @item = FactoryGirl.create(:inventory_item)
    end

    it "destroys an empty built shipping box" do
      @item.shipping_box.weight = nil
      @item.shipping_box.length = nil
      @item.shipping_box.width  = nil
      @item.shipping_box.height = nil

      @item.remove_empty_shipping_box
      ShippingBox.all.should == []
    end

    it "allows persistance when shipping box is valid" do
      @item.remove_empty_shipping_box
      @item.shipping_box.should_not == nil
    end
  end
end

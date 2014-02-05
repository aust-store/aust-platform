require 'spec_helper'

describe InventoryItem do
  it_should_behave_like "uuid", :inventory_item, :uuid

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
        result[0].entry_for_website_sale.id.should == items[0].balances.last.id
        result[1].entry_for_website_sale.id.should == items[1].balances.last.id
      end
    end

    describe "#with_website_sale" do
      it "should return the correct entries" do
        # each item has 3 entries
        item1 = FactoryGirl.create(:inventory_item, website_sale: true)
        FactoryGirl.create(:inventory_item, website_sale: false)

        InventoryItem.with_website_sale.to_a.should == [item1]
      end
    end

    describe "#with_point_of_sale" do
      it "should return the correct entries" do
        # each item has 3 entries
        item1 = FactoryGirl.create(:inventory_item, point_of_sale: true)
        FactoryGirl.create(:inventory_item, point_of_sale: false)

        InventoryItem.with_point_of_sale.to_a.should == [item1]
      end
    end

    describe "#by_category" do
      let(:level1_category) { create(:single_taxonomy) }
      let(:level2_category) { create(:single_taxonomy, parent: level1_category) }
      let(:level3_category) { create(:single_taxonomy, parent: level2_category) }
      let(:level4_category) { create(:single_taxonomy, parent: level3_category) }

      it "returns only items in the given category and below" do
        item1 = create(:inventory_item, taxonomy: level1_category)
        item2 = create(:inventory_item, taxonomy: level2_category)
        item3 = create(:inventory_item, taxonomy: level3_category)
        item4 = create(:inventory_item, taxonomy: level4_category)

        results = InventoryItem.by_category(level2_category.id)
        results.should_not include item1
        results.should include item2, item3, item4
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

  describe "#price_for_installments" do
    let(:item_price) { double }

    it "should delegate to ItemPrice" do
      item = InventoryItem.new
      Store::ItemPrice.stub(:new).with(item) { item_price }
      item_price.should_receive(:price_for_installments)

      item.price_for_installments
    end
  end

  describe "#entry_for_website_sale" do
    before do
      @item = FactoryGirl.create(:inventory_item)
    end

    it "loads the first entry for sale" do
      entries = @item.balances.order("id asc").to_a
      @item.entry_for_website_sale.should == entries.first
      InventoryEntry.first.update_attribute(:on_sale, false)
      @item.entry_for_website_sale.should == entries.second
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

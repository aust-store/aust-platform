require 'spec_helper'

describe InventoryItem do
  it_should_behave_like "uuid", :inventory_item, :uuid

  describe "scopes" do
    describe "#with_entry_for_sale" do
      let(:item1) { create(:inventory_item) }
      let(:item2) { create(:inventory_item) }
      let(:item3) { create(:inventory_item) }

      before do
        # each item has 3 entries
        item1 and item2 and item3
      end

      it "should return the correct entries" do
        items = InventoryItem.order("id ASC").first(2)
        items[0].balances.first .update_attribute(:on_sale, false)
        items[0].balances.second.update_attribute(:on_sale, false)
        items[1].balances.first .update_attribute(:on_sale, false)
        items[1].balances.second.update_attribute(:on_sale, false)

        result = InventoryItem.with_entry_for_sale.limit(2).order("inventory_items.id ASC")
        result[0].entry_for_website_sale.id.should == items[0].balances.last.id
        result[1].entry_for_website_sale.id.should == items[1].balances.last.id
      end

      it "returns items missing a shipping box" do
        item2.shipping_box = nil
        item2.save

        result = InventoryItem.with_entry_for_sale.limit(2).order("inventory_items.id ASC")
        result.should == [item1, item2]
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

  # this method belongs to acts_as_taggable, but I want to make sure it
  # works as I expect.
  describe ".all_tags" do
    let(:company) { create(:barebone_company) }

    before do
      create(:inventory_item_without_associations, tag_list: ["f"], company: company)
      @item = create(:inventory_item_without_associations, tag_list: ["e"], company: company)
      create(:inventory_item_without_associations, tag_list: ["d"])
    end

    it "returns only the tags belongs to the company" do
      company.items.all_tags.map(&:name).sort.should == %w(e f)
      @item.destroy
      company.reload
      company.items.all_tags.map(&:name).should == %w(f)
    end
  end

  describe "#search_for" do
    let(:company) { create(:barebone_company) }
    let(:category) { create(:taxonomy, name: "Superb") }
    let!(:item1)  { create(:inventory_item,
                           company: company,
                           reference_number: "x1393",
                           name: "my item") }
    let!(:item2)  { create(:inventory_item,
                           company: company,
                           name: "ur item2",
                           manufacturer_id: nil,
                           taxonomy: category,
                           reference_number: "x1397",
                           tag_list: %w(preowned)) }
    let!(:item3)  { create(:inventory_item,
                           name: "ur item2",
                           tag_list: %w(preowned)) }

    it "searches by name" do
      company.items.search_for("item2").to_a.should == [item2]
    end

    it "searches by tags" do
      company.items.search_for("preowned").to_a.should == [item2]
      company.items.search_for("used").to_a.should == [item1]
    end

    it "searches by categories" do
      company.items.search_for("superb").to_a.should == [item2]
    end

    it "searches by reference number" do
      company.items.search_for("x1").to_a.should match_array([item1, item2])
      company.items.search_for("x13").to_a.should match_array([item1, item2])
      company.items.search_for("x139").to_a.should match_array([item1, item2])
      company.items.search_for("x1397").to_a.should match_array([item2])
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

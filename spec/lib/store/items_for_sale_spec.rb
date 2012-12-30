require "unit_spec_helper"
require "store/items_for_sale"

describe Store::ItemsForSale do
  it_should_behave_like "loading store contract"

  before do
    @store = double
    @controller = double(current_store: @store)
  end

  describe "#items_for_main_page" do
    # TODO define contracts with controller
    it "returns items from the current store" do
      @store.stub(:items_on_sale_on_main_page) { [1, 2, 3] }
      @controller.stub(:current_store) { @store }

      items = Store::ItemsForSale.new(@controller).items_for_main_page
      items.should == [1, 2, 3]
    end
  end

  describe "#item_for_cart" do
    it "returns an inventory entry given an id" do
      entries_model = double
      entries_model.stub(:find).with(2) { :entry }
      @store.stub(:inventory_entries) { entries_model }
      @controller.stub(:params) { {id: 2} }

      items = Store::ItemsForSale.new(@controller).item_for_cart
      items.should == :entry
    end
  end

  describe "#detailed_item_for_show_page" do
    it "returns a detailed item for a given id" do
      entries_model = double
      entry = double
      product = double
      item = double(id: :id)

      @store.stub(:inventory_entries) { entries_model }
      entries_model.stub(:find).with(2) { entry }
      entry.stub(:inventory_item) { item }
      @store.stub(:detailed_item).with(:id) { product }
      @controller.stub(:params) { {id: 2} }

      detailed_item = Store::ItemsForSale.new(@controller).detailed_item_for_show_page
      detailed_item.should == product
    end
  end
end

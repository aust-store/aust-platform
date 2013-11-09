require "unit_spec_helper"
require "store/items_for_sale"

describe Store::ItemsForSale do
  it_should_behave_like "loading store contract"

  let(:params) { {} }

  before do
    @store = double
    @controller = double(current_store: @store, params: params)
  end

  describe "#items_for_main_page" do
    # TODO define contracts with controller
    it "returns items from the current store" do
      @store.stub(:items_on_sale_on_main_page) { [1, 2, 3] }

      items = Store::ItemsForSale.new(@controller).items_for_main_page
      items.should == [1, 2, 3]
    end
  end

  describe "#items_for_category" do
    # TODO define contracts with controller
    let(:params) { {id: 1} }

    it "returns items from the current store" do
      @store.stub(:items_on_sale_in_category).with(1) { [:item1, :item2] }

      items = Store::ItemsForSale.new(@controller).items_for_category
      items.should == [:item1, :item2]
    end
  end

  describe "#item_for_cart" do
    let(:item) { double }

    it "returns an inventory entry given an id" do
      item.stub(:entry_for_sale) { :entry }

      items = Store::ItemsForSale.new(@controller).item_for_cart(item)
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
      entries_model.stub(:find).with(:slug) { entry }
      entry.stub(:inventory_item) { item }
      @store.stub(:detailed_item).with(:slug) { product }
      @controller.stub(:params) { {id: :slug} }

      detailed_item = Store::ItemsForSale.new(@controller).detailed_item_for_show_page
      detailed_item.should == product
    end
  end
end

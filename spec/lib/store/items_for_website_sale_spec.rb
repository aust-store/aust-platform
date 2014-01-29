require "spec_helper"

describe Store::ItemsForWebsiteSale do
  it_should_behave_like "loading store contract"

  let(:params) { {} }

  before do
    @store = double
    @controller = double(current_store: @store, params: params)
  end

  describe "#items_for_main_page" do
    # TODO define contracts with controller
    it "returns items from the current store" do
      @store.stub(:items_on_sale_for_website_main_page) { [1, 2, 3] }

      items = Store::ItemsForWebsiteSale.new(@controller).items_for_main_page
      items.should == [1, 2, 3]
    end
  end

  describe "#items_for_category" do
    # TODO define contracts with controller
    let(:params) { {id: 1} }

    it "returns items from the current store" do
      @store.stub(:items_on_sale_in_category_for_website).with(1) { [:item1, :item2] }

      items = Store::ItemsForWebsiteSale.new(@controller).items_for_category
      items.should == [:item1, :item2]
    end
  end

  describe "#item_for_cart" do
    let(:item) { double }

    it "returns an inventory entry given an id" do
      item.stub(:entry_for_website_sale) { :entry }

      items = Store::ItemsForWebsiteSale.new(@controller).item_for_cart(item)
      items.should == :entry
    end
  end

  describe "#detailed_item_for_show_page" do
    let(:product) { double }

    it "returns a detailed item for a given id" do
      @store.stub(:detailed_item).with(2) { product }

      detailed_item = Store::ItemsForWebsiteSale.new(@controller).detailed_item_for_show_page(2)
      detailed_item.should == product
    end
  end
end

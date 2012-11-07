require "store/items_for_sale"

describe Store::ItemsForSale do
  describe "#items_for_homepage" do
    let(:store) { double }
    let(:controller) { double(current_store: store) }

    # TODO define contracts with controller
    it "returns items from the current store" do
      store.stub(:distinct_items) { [1, 2, 3] }
      controller.stub(:current_store) { store }

      items = Store::ItemsForSale.new(controller).items_for_homepage
      items.should == [1, 2, 3]
    end
  end

  describe "#item_for_cart" do
    let(:store) { double }
    let(:controller) { double(current_store: store) }

    it "returns an inventory entry given an id" do
      entries_model = double
      entries_model.stub(:find).with(2) { :entry }
      store.stub(:inventory_entries) { entries_model }
      controller.stub(:params) { {id: 2} }

      items = Store::ItemsForSale.new(controller).item_for_cart
      items.should == :entry
    end
  end
end

require "spec_helper"

describe Store::HomeController do
  describe "GET index" do
    it "returns a list of entries in the inventory" do
      Store::ItemsForSale.stub(:new).with(controller) { double(items_for_main_page: :entries) }
      Store::InventoryItemDecorator.stub(:decorate).with(:entries) { :entries }

      get :index, store_id: "store_name"
      assigns(:items).should == :entries
    end
  end
end

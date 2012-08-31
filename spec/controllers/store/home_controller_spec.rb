require "spec_helper"

describe Store::HomeController do
  describe "GET index" do
    it "returns a list of entries in the inventory" do
      Store::ItemsForSale.stub(:new).with(controller) { double(items_for_homepage: :entries) }
      get :index, store_id: "store_name"
      assigns(:entries).should == :entries
    end
  end
end

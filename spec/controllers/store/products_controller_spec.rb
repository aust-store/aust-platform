require 'spec_helper'

describe Store::ProductsController do
  describe "GET show" do
    it "loads a products by id" do
      entries = double(inventory_entry: :entry)
      Store::ItemsForSale.stub(:new).with(controller) { entries }
      get :show, store_id: "name", id: 1
      assigns(:product).should == :entry
    end
  end
end

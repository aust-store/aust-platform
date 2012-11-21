require 'spec_helper'

describe Store::ProductsController do
  describe "GET show" do
    it "loads a products by id" do
      product = double
      entry = double(detailed_item_for_show_page: :detailed_item_for_show_page)

      Store::ItemsForSale.stub(:new).with(controller) { entry }
      DecorationBuilder.stub(:inventory_items) { product }

      get :show, store_id: "name", id: 1
      assigns(:product).should == product
    end
  end
end
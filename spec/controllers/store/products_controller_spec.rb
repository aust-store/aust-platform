require "spec_helper"

describe Store::ProductsController do
  describe "GET show" do
    it "instantiates a new inventory item" do
      Store::ItemsForSale
        .stub(:new)
        .with(controller)
        .and_return(double(inventory_entry: :item))
      get :show, store_id: "store_name", id: 2
      assigns(:product).should == :item
    end
  end
end

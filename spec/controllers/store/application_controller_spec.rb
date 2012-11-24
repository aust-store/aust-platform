require "spec_helper"

describe Store::HomeController do
  describe "GET index" do
    before do
      Store::ItemsForSale.stub(:new).with(controller) { double(items_for_main_page: :entries) }
    end

    it "should instantiate @company through Store::ApplicationController" do
      Company.should_receive(:find_by_handle).with("store") { :company }
      get :index, store_id: "store"
      assigns(:company).should == :company
    end
  end
end

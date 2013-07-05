require "spec_helper"

describe Store::HomeController do
  let(:company) { double.as_null_object }

  describe "GET index" do
    it "returns a list of entries in the inventory" do
      Store::ItemsForSale.stub(:new).with(controller) { double(items_for_main_page: :entries) }
      Store::InventoryItemDecorator.stub(:decorate_collection).with(:entries) { :entries }
      Company.stub_chain(:where, :first) { company }
      company.stub(:taxonomies) { double.as_null_object }

      get :index
      assigns(:items).should == :entries
    end
  end
end

# Store::ApplicationController
#
# Testing before_filter triggers in superclass via StoreController
#
#   before_filter :set_layout
#
require "integration_spec_helper"

describe Store::HomeController, type: :controller do
  describe "GET index" do
    let(:company) { double(list_goods: :goods) }

    it "should instantiate @company through Store::ApplicationController" do
      Company.should_receive(:where).with(handle: "1") { double(first: company) }
      get "store/1"
      assigns(:company).should == company
    end

    it "loads the list of goods" do
      Company.stub(:where).with(handle: "1") { double(first: company) }
      get "store/1"
      assigns(:goods).should == :goods
    end
  end
end

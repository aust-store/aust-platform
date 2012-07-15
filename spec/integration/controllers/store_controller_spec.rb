# Store::ApplicationController
#
# Testing before_filter triggers in superclass via StoreController
#
#   before_filter :set_layout
#
require "integration_spec_helper"

describe Store::HomeController, type: :controller do
  describe "GET index" do
    it "should instantiate @company through Store::ApplicationController" do
      company = double(first: :company)
      Company.should_receive(:where).with(handle: "1") { company }
      get "store/1"
      assigns(:company).should == :company
    end
  end
end

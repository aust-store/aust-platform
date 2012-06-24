require 'integration_spec_helper'

describe Admin::Goods::SearchController do
  login_admin

  before do
    Good.stub(:search_for).and_return("result")
  end

  describe "POST for_adding_balance" do
    it "instantiate @resource" do
      post :for_adding_balance
      assigns(:resources).should == "result"
    end

    it "generates the correct route path" do
      post :for_adding_balance
      assigns(:path).call(1).should == "/admin/inventory/goods/1/balances/new"
    end
  end

  describe "POST index" do
    it "instantiate @resource" do
      post :index
      assigns(:resources).should == "result"
    end

    it "generates the correct route path" do
      post :index
      assigns(:path).call(1).should == "/admin/inventory/goods/1"
    end
  end
end

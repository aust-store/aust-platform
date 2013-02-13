require "spec_helper"

describe Store::HomeController do
  describe "how domains are loaded" do
    context "given petshop.store.com" do
      before { request.host = "petshop.store.com" }

      it "loads the company correctly based on the subdomain petshop" do
        company = FactoryGirl.create(:company, handle: "petshop")
        get :index
        assigns(:company).should == company
      end

      it "loads the company correctly based on the domain store.com" do
        company = FactoryGirl.create(:company, handle: "handle", domain: "store.com")
        get :index
        assigns(:company).should == company
      end
    end

    context "given petshop.store.com.br" do
      before { request.host = "petshop.store.com.br" }

      it "loads the company correctly based on the subdomain petshop" do
        company = FactoryGirl.create(:company, handle: "petshop")
        get :index
        assigns(:company).should == company
      end

      it "loads the company correctly based on the domain store.com" do
        company = FactoryGirl.create(:company, handle: "handle", domain: "store.com.br")
        get :index
        assigns(:company).should == company
      end
    end

    context "given store.com.br" do
      before { request.host = "store.com.br" }

      it "loads the company correctly based on the domain store.com" do
        company = FactoryGirl.create(:company, handle: "handle", domain: "store.com.br")
        get :index
        assigns(:company).should == company
      end
    end

    context "given www.store.com.br" do
      before { request.host = "www.store.com.br" }

      it "loads the company correctly based on the domain store.com" do
        company = FactoryGirl.create(:company, handle: "handle", domain: "store.com.br")
        get :index
        assigns(:company).should == company
      end
    end
  end
end

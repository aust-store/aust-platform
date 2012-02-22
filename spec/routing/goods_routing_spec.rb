require "spec_helper"

describe GoodsController do
  describe "routing" do

    it "routes to #index" do
      get("/goods").should route_to("goods#index")
    end

    it "routes to #new" do
      get("/goods/new").should route_to("goods#new")
    end

    it "routes to #show" do
      get("/goods/1").should route_to("goods#show", :id => "1")
    end

    it "routes to #edit" do
      get("/goods/1/edit").should route_to("goods#edit", :id => "1")
    end

    it "routes to #create" do
      post("/goods").should route_to("goods#create")
    end

    it "routes to #update" do
      put("/goods/1").should route_to("goods#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/goods/1").should route_to("goods#destroy", :id => "1")
    end

  end
end

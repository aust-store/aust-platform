require 'spec_helper'

describe Admin::Api::ResourcesController do
  describe "GET show" do
    it "returns a given model's attributes list" do
      get :show, model: "order"

      json = ActiveSupport::JSON.decode(response.body)
      json.should == {
        "order" => {
          "attributes" => ["id", "total", "created_at", "environment"],
          "associations" => ["order_items"]
        }
      }
    end
  end
end

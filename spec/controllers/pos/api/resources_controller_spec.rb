require 'spec_helper'

describe Pos::Api::ResourcesController do
  describe "GET show" do
    describe "order model" do
      it "returns a given model's attributes list" do
        get :show, model: "order"

        json = ActiveSupport::JSON.decode(response.body)
        json.should == {
          "order" => {
            "attributes" => [
              "id",
              "total",
              "created_at",
              "environment",
              "payment_type"
            ],
            "associations" => ["items", "customer", "cart"]
          }
        }
      end
    end
  end
end

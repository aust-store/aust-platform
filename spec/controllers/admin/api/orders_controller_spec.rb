require 'spec_helper'

describe Admin::Api::OrdersController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "POST create" do
    it "creates orders with embedded order items" do
      inventory_item = FactoryGirl.create(:inventory_item, company: @company)

      json_request = {
        "order" => {
          "items" => [
            { "price" => 50,
              "inventory_item_id" => inventory_item.id }
          ]
        }
      }
      xhr :post, :create, json_request

      order = Order.first
      item  = OrderItem.first
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "order" => {
          "id"    => order.id,
          "total" => "50.0",
          "items"=>[
            { "id"                 => item.id,
              "name"               => item.name,
              "quantity"           => item.quantity,
              "price"              => item.price.to_s,
              "inventory_item_id"  => item.inventory_item_id,
              "inventory_entry_id" => 1 }
          ]
        }
      }
    end
  end

  describe "PUT update" do
    it "updates orders with embedded order items" do
      inventory_item = FactoryGirl.create(:inventory_item, company: @company)
      order          = FactoryGirl.create(:order, store: @company)

      json_request = {
        "id"    => order.id,
        "order" => {
          "items" => [
            { "id"    => order.items.first.id,
              "price" => 50,
              "inventory_item_id" => inventory_item.id },

            { "price"    => 60,
              "order_id" => order.id,
              "inventory_item_id" => inventory_item.id }
          ]
        }
      }
      xhr :put, :update, json_request

      order    = Order.first
      created_item = OrderItem.first
      updated_item = OrderItem.last
      json     = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "order" => {
          "id"    => order.id,
          "total" => "110.0",
          "items" => [
            { "id"                 => updated_item.id,
              "name"               => updated_item.name,
              "quantity"           => updated_item.quantity,
              "price"              => updated_item.price.to_s,
              "inventory_item_id"  => updated_item.inventory_item_id,
              "inventory_entry_id" => nil },

            { "id"                 => created_item.id,
              "name"               => created_item.name,
              "quantity"           => created_item.quantity,
              "price"              => created_item.price.to_s,
              "inventory_item_id"  => created_item.inventory_item_id,
              "inventory_entry_id" => nil }
          ]
        }
      }
    end
  end
end

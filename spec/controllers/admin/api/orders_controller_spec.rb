require 'spec_helper'

describe Admin::Api::OrdersController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET index" do
    context "all orders" do
      it "returns the last 50 orders with embedded order items" do
        order = FactoryGirl.create(:order, store: @company, total_items: 1)

        xhr :get, :index

        order = Order.first
        items = order.items.to_a
        json  = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "orders" => [
            { "id"         => order.id,
              "total"      => order.total.to_s,
              "created_at" => order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
              "items" => [
                { "id"                 => items[0].id,
                  "name"               => items[0].name,
                  "quantity"           => items[0].quantity,
                  "price"              => items[0].price.to_s,
                  "inventory_item_id"  => items[0].inventory_item_id,
                  "inventory_entry_id" => items[0].inventory_entry_id }
              ]
            }
          ]
        }
      end
    end

    context "offline orders" do
      it "returns the last 50 offline orders" do
        order = FactoryGirl.create(:offline_order, store: @company, total_items: 1)
        irrelevant_order = FactoryGirl.create(:order, store: @company, total_items: 1)

        xhr :get, :index, environment: "offline"

        order = Order.first
        items = order.items.to_a
        json  = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "orders" => [
            { "id"         => order.id,
              "total"      => order.total.to_s,
              "created_at" => order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
              "items" => [
                { "id"                 => items[0].id,
                  "name"               => items[0].name,
                  "quantity"           => items[0].quantity,
                  "price"              => items[0].price.to_s,
                  "inventory_item_id"  => items[0].inventory_item_id,
                  "inventory_entry_id" => items[0].inventory_entry_id }
              ]
            }
          ]
        }
      end
    end
  end

  describe "POST create" do
    it "creates orders with embedded order items" do
      inventory_item = FactoryGirl.create(:inventory_item, company: @company)
      # 4 order items are created
      cart = FactoryGirl.create(:offline_cart, company: @company)
      cart_item = cart.items.first

      json_request = {
        "order" => {
          "cart" => {
            "id"    => cart.id,
            "items" => [
              { "id"                 => cart_item.id,
                "price"              => cart_item.price.to_s,
                "inventory_entry_id" => cart_item.inventory_item_id,
                "inventory_item_id"  => cart_item.inventory_entry_id }
            ]
          }
        }
      }
      xhr :post, :create, json_request

      order = Order.first
      json  = ActiveSupport::JSON.decode(response.body)

      json["order"].should include(
        { "id"    => order.id,
          "total" => order.total.to_s }
      )

      cart.items.each do |item|
        json["order"]["items"].should include(
          { "id"                 => item.id,
            "name"               => item.name,
            "quantity"           => item.quantity,
            "price"              => item.price.to_s,
            "inventory_item_id"  => item.inventory_item_id,
            "inventory_entry_id" => item.inventory_entry_id }
        )
      end
    end
  end
end

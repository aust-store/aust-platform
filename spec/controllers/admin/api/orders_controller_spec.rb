require 'spec_helper'

describe Admin::Api::OrdersController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

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

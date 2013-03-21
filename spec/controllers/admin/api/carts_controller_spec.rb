require 'spec_helper'

describe Admin::Api::CartsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "POST create" do
    it "creates carts with embedded order items" do
      inventory_item = FactoryGirl.create(:inventory_item, company: @company)
      entry = inventory_item.entries.first

      json_request = {
        "cart" => {
          "items" => [
            { "price" => 50,
              "inventory_entry_id" => entry.id,
              "inventory_item_id"  => inventory_item.id }
          ]
        }
      }
      xhr :post, :create, json_request

      cart  = Cart.first
      item  = OrderItem.first
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "cart" => {
          "id"    => cart.id,
          "total" => "50.0",
          "items"=>[
            { "id"                 => item.id,
              "name"               => item.name,
              "quantity"           => 1,
              "price"              => item.price.to_s,
              "inventory_item_id"  => item.inventory_item_id,
              "inventory_entry_id" => entry.id }
          ]
        }
      }
    end
  end

  describe "PUT update" do
    it "updates cart with embedded order items" do
      inventory_item = FactoryGirl.create(:inventory_item, company: @company)
      cart           = FactoryGirl.create(:cart, company: @company)

      json_request = {
        "id"    => cart.id,
        "cart" => {
          "items" => [
            { "id"    => cart.items.parent_items.first.id,
              "price" => 50,
              "inventory_item_id" => inventory_item.id },

            { "price"    => 60,
              "cart_id" => cart.id,
              "inventory_item_id" => inventory_item.id }
          ]
        }
      }
      xhr :put, :update, json_request

      cart = Cart.first
      json = ActiveSupport::JSON.decode(response.body)

      json["cart"].should include(
        { "id"    => cart.id,
          "total" => "427.28" }
      )

      # returns all items, not only the ones that were sent via PUT
      cart.items.each do |item|
        json["cart"]["items"].should include(
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

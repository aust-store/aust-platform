require 'spec_helper'

describe Admin::Api::CartItemsController do
  login_admin

  let(:cart) { create(:cart, company: @company) }

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  before do
    cart
  end

  describe "POST create" do
    it "creates cart items" do
      inventory_item = FactoryGirl.create(:inventory_item, company: @company)
      entry = inventory_item.entries.first

      json_request = {
        "cart_item" => {
          "price" => 50,
          "inventory_entry_id" => entry.id,
          "inventory_item_id"  => inventory_item.id,
          "cart_id" => cart.id
        }
      }
      xhr :post, :create, json_request

      item  = OrderItem.last
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "cart_item" => {
          "id"                 => item.id,
          "name"               => item.name,
          "quantity"           => 1,
          "price"              => item.price.to_s,
          "inventory_entry_id" => entry.id,
          "inventory_item_id"  => item.inventory_item_id,
          "cart_id"            => cart.id
        },
        "inventory_items" => [{
          "id"                 => item.inventory_item.id,
          "name"               => item.name,
          "description"        => item.inventory_item.description,
          "price"              => item.inventory_item.price.to_s,
          "entry_for_sale_id"  => entry.id,
          "on_sale"            => true
        }]
      }
    end
  end
end

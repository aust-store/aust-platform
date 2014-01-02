require 'spec_helper'

describe Admin::Api::CartsController do
  login_admin

  let(:cart) { create(:offline_cart, company: @company) }
  let(:customer) { create(:customer, store: @company) }

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "POST create" do
    it "creates carts" do
      xhr :post, :create, { cart: {total: 0} }

      cart  = Cart.first
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "cart" => {
          "id"    => cart.id,
          "total" => "0.0",
          "cart_item_ids" => []
        },
        "cart_items" => [],
      }
    end
  end

  describe "PUT update" do
    it "updates carts" do
      xhr :put, :update, {
        id: cart.id,
        cart: {
          total: 0,
          customer_id: customer.uuid
        }
      }

      json = ActiveSupport::JSON.decode(response.body)
      cart.reload

      json.should == {
        "cart" => {
          "id"    => cart.id,
          "total" => "55.76",
          "cart_item_ids" => cart.items.map(&:id),
          "customer_id" => customer.uuid
        },
        "cart_items" => cart.items.map { |item|
          { "id" => item.id,
            "name" => item.name,
            "quantity" => item.quantity,
            "price" => item.price.to_s,
            "inventory_entry_id" => item.inventory_entry_id,
            "order_id" => nil,
            "inventory_item_id" => item.inventory_item_id
          }
        },
        "customers" => [{
          "id" => customer.uuid,
          "first_name" => customer.first_name,
          "last_name" => customer.last_name,
          "email" => customer.email,
          "social_security_number" => customer.social_security_number
        }]
      }
    end
  end
end

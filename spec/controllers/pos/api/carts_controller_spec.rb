require 'spec_helper'

describe Pos::Api::CartsController do
  include_context "an authenticable token"

  let(:admin_user) { create(:admin_user) }
  let(:cart) { create(:offline_cart, company: admin_user.company) }
  let(:customer) { create(:customer, store: admin_user.company) }

  before do
    set_oauth_header(user: admin_user)
  end

  after do
    response.should have_proper_api_headers
  end

  describe "POST create" do
    it "creates carts" do
      pregenerated_uuid = SecureRandom.uuid
      request_json = {
        cart: {
          id: pregenerated_uuid,
          total: 0,
        }
      }
      xhr :post, :create, request_json

      cart  = Cart.first
      cart.uuid.should == pregenerated_uuid
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "cart" => {
          "id"    => pregenerated_uuid,
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
        id: cart.uuid,
        cart: {
          total: 0,
          customer_id: customer.uuid
        }
      }

      json = ActiveSupport::JSON.decode(response.body)
      cart.reload

      json.should == {
        "cart" => {
          "id"    => cart.uuid,
          "total" => "55.76",
          "cart_item_ids" => cart.items.map(&:uuid),
          "customer_id" => customer.uuid
        },
        "cart_items" => cart.items.map { |item|
          { "id" => item.uuid,
            "name" => item.name,
            "quantity" => item.quantity,
            "price" => item.price.to_s,
            "price_for_installments" => item.price_for_installments.to_s,
            "inventory_entry_id" => item.inventory_entry_id,
            "order_id" => nil,
            "inventory_item_id" => item.inventory_item.uuid
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

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
        carts: {
          id: pregenerated_uuid,
          total: 0,
        }
      }
      xhr :post, :create, request_json

      cart  = Cart.first
      cart.uuid.should == pregenerated_uuid
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "carts" => {
          "id"    => pregenerated_uuid,
          "total" => "0.0",
          "links" => {
            "items" => [],
            "customer" => nil
          }
        }
      }
    end
  end

  describe "PUT update" do
    it "updates carts" do
      xhr :put, :update, {
        id: cart.uuid,
        carts: {
          total: 0,
          customer_id: customer.uuid
        }
      }

      json = ActiveSupport::JSON.decode(response.body)
      cart.reload

      json.should == {
        "carts" => {
          "id"    => cart.uuid,
          "total" => "55.76",
          "links" => {
            "items" => {
              "type" => "order_items",
              "ids" => cart.items.map(&:uuid),
            },
            "customer" => {
              "type" => "person",
              "id" => "#{customer.uuid}"
            }
          }
        }
      }
    end
  end
end

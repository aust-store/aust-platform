require 'spec_helper'

describe Pos::Api::CartItemsController do
  include_context "an authenticable token"

  let(:admin_user) { create(:admin_user) }
  let(:cart) { create(:cart, company: admin_user.company) }
  let(:inventory_item) { create(:inventory_item, company: admin_user.company) }

  before do
    cart
    request.headers['Authorization'] = "Token token=\"#{admin_user.api_token}\""
  end

  describe "POST create" do
    after do
      response.should have_proper_api_headers
    end

    context "no id is passed in" do
      it "creates cart items" do
        entry = inventory_item.entries.first

        json_request = {
          "cart_item" => {
            "price" => 50,
            "price_for_installments" => 500,
            "inventory_entry_id" => entry.id,
            "inventory_item_id"  => inventory_item.uuid,
            "cart_id" => cart.uuid
          }
        }

        xhr :post, :create, json_request

        item = OrderItem.last
        json = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "cart_item" => {
            "id"                 => item.uuid,
            "name"               => item.name,
            "quantity"           => 1,
            "price"              => item.price.to_s,
            "price_for_installments" => item.price_for_installments.to_s,
            "inventory_entry_id" => entry.id,
            "inventory_item_id"  => item.inventory_item.uuid,
            "cart_id"            => cart.uuid
          },
          "inventory_items" => [{
            "id"                 => item.inventory_item.uuid,
            "name"               => item.name,
            "description"        => item.inventory_item.description,
            "price"              => item.inventory_item.price.to_s,
            "price_for_installments" => "16.01",
            "entry_for_sale_id"  => entry.id,
            "on_sale"            => true,
            "barcode"            => "123",
            "reference_number"   => "1234"
          }]
        }
      end
    end

    context "a uuid is passed in" do
      it "creates cart items" do
        entry = inventory_item.entries.first
        pregenerated_uuid = SecureRandom.uuid

        json_request = {
          "cart_item" => {
            "id" => pregenerated_uuid,
            "price" => 50,
            "price_for_installments" => 500,
            "inventory_entry_id" => entry.id,
            "inventory_item_id"  => inventory_item.uuid,
            "cart_id" => cart.uuid
          }
        }
        xhr :post, :create, json_request

        item  = OrderItem.last
        json  = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "cart_item" => {
            "id"                 => pregenerated_uuid,
            "name"               => item.name,
            "quantity"           => 1,
            "price"              => "50.0",
            "price_for_installments" => "500.0",
            "inventory_entry_id" => entry.id,
            "inventory_item_id"  => item.inventory_item.uuid,
            "cart_id"            => cart.uuid
          },
          "inventory_items" => [{
            "id"                 => item.inventory_item.uuid,
            "name"               => item.name,
            "description"        => item.inventory_item.description,
            "price"              => item.inventory_item.price.to_s,
            "price_for_installments" => item.inventory_item.price_for_installments.to_s,
            "entry_for_sale_id"  => entry.id,
            "on_sale"            => true,
            "barcode"            => "123",
            "reference_number"   => "1234"
          }]
        }
      end
    end
  end

  describe "DELETE destroy" do
    let(:cart_item) { create(:cart_item, cart: cart) }

    before do
      cart_item
    end

    after do
      response.should have_proper_api_headers
    end

    it "deletes a cart item" do
      xhr :delete, :destroy, id: cart_item.uuid

      json = ActiveSupport::JSON.decode(response.body)
      json.should == {}
    end

    it "returns success even if a cart item doesn't exist" do
      xhr :delete, :destroy, id: 123
      json = ActiveSupport::JSON.decode(response.body)
      json.should == {}
    end
  end
end

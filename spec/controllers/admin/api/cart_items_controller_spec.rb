require 'spec_helper'

describe Admin::Api::CartItemsController do
  login_admin

  let(:cart) { create(:cart, company: @company) }
  let(:inventory_item) { create(:inventory_item, company: @company) }

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  before do
    cart
  end

  describe "POST create" do
    context "no id is passed in" do
      it "creates cart items" do
        entry = inventory_item.entries.first

        json_request = {
          "cart_item" => {
            "price" => 50,
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
            "id"                 => item.uuid,
            "name"               => item.name,
            "quantity"           => 1,
            "price"              => item.price.to_s,
            "inventory_entry_id" => entry.id,
            "inventory_item_id"  => item.inventory_item.uuid,
            "cart_id"            => cart.uuid
          },
          "inventory_items" => [{
            "id"                 => item.inventory_item.uuid,
            "name"               => item.name,
            "description"        => item.inventory_item.description,
            "price"              => item.inventory_item.price.to_s,
            "entry_for_sale_id"  => entry.id,
            "on_sale"            => true,
            "barcode"            => "123"
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
            "price"              => item.price.to_s,
            "inventory_entry_id" => entry.id,
            "inventory_item_id"  => item.inventory_item.uuid,
            "cart_id"            => cart.uuid
          },
          "inventory_items" => [{
            "id"                 => item.inventory_item.uuid,
            "name"               => item.name,
            "description"        => item.inventory_item.description,
            "price"              => item.inventory_item.price.to_s,
            "entry_for_sale_id"  => entry.id,
            "on_sale"            => true,
            "barcode"            => "123"
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

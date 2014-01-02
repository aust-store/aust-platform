require 'spec_helper'

describe Admin::Api::OrdersController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET index" do
    let(:website_order) { create(:order, store: @company, total_items: 1) }
    let(:offline_order) { create(:offline_order, store: @company, total_items: 1) }

    before do
      website_order and offline_order
    end

    context "all orders" do
      it "returns the last 50 orders" do
        xhr :get, :index

        json = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "orders" => [{
            "id"          => offline_order.uuid,
            "total"       => offline_order.total.to_s,
            "created_at"  => offline_order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "environment" => "offline",
            "customer_id" => offline_order.customer.uuid,
          }, {
            "id"          => website_order.uuid,
            "total"       => website_order.total.to_s,
            "created_at"  => website_order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "environment" => "website",
            "customer_id" => website_order.customer.uuid,
          }],
          "customers" => [{
            "id"         => offline_order.customer.uuid,
            "first_name" => offline_order.customer.first_name,
            "last_name"  => offline_order.customer.last_name,
            "email"      => offline_order.customer.email,
            "social_security_number" => offline_order.customer.social_security_number
          }, {
            "id"         => website_order.customer.uuid,
            "first_name" => website_order.customer.first_name,
            "last_name"  => website_order.customer.last_name,
            "email"      => website_order.customer.email,
            "social_security_number" => website_order.customer.social_security_number
          }]
        }
      end
    end

    context "offline orders" do
      it "returns the last 50 offline orders" do
        xhr :get, :index, environment: "offline"

        json  = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "orders" => [{
            "id"          => offline_order.uuid,
            "total"       => offline_order.total.to_s,
            "created_at"  => offline_order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "environment" => "offline",
            "customer_id" => offline_order.customer.uuid
          }],
          "customers" => [{
            "id"         => offline_order.customer.uuid,
            "first_name" => offline_order.customer.first_name,
            "last_name"  => offline_order.customer.last_name,
            "email"      => offline_order.customer.email,
            "social_security_number" => offline_order.customer.social_security_number
          }]
        }
      end
    end
  end

  describe "POST create" do
    it "creates orders with embedded order items" do
      # 4 order items are created
      cart = FactoryGirl.create(:offline_cart, company: @company)
      json_request = {
        "order" => {
          "cart_id" => cart.uuid
        }
      }
      xhr :post, :create, json_request

      order = Order.first
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "order" => {
          "id"             => order.uuid,
          "total"          => order.total.to_s,
          "created_at"     => order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
          "environment"    => "offline",
          "order_item_ids" => order.items.map(&:id),
          "customer_id"    => order.customer.uuid
        },
        "order_items" => order.items.map { |item|
          { "id"                 => item.id,
            "name"               => item.name,
            "quantity"           => item.quantity,
            "price"              => item.price.to_s,
            "inventory_item_id"  => item.inventory_item_id,
            "order_id"           => order.id,
            "inventory_entry_id" => item.inventory_entry_id }
        },
        "customers" => [{
          "id"         => order.customer.uuid,
          "first_name" => order.customer.first_name,
          "last_name"  => order.customer.last_name,
          "email"      => order.customer.email,
          "social_security_number" => order.customer.social_security_number
        }]
      }

      order.items.each do |item|
        json["order_items"].should include(
          { "id"                 => item.id,
            "name"               => item.name,
            "quantity"           => item.quantity,
            "price"              => item.price.to_s,
            "inventory_item_id"  => item.inventory_item_id,
            "order_id"           => order.id,
            "inventory_entry_id" => item.inventory_entry_id }
        )
      end
    end
  end
end

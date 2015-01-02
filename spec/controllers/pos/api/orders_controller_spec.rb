require 'spec_helper'

describe Pos::Api::OrdersController do
  include_context "an authenticable token"

  it_behaves_like "an api endpoint with date search", :orders, :offline_order
  it_behaves_like "an api endpoint returning only own user resources", :orders, :offline_order

  let(:admin_user) { create(:admin_user) }
  let(:pregenerated_uuid) { SecureRandom.uuid }

  before do
    set_oauth_header(user: admin_user)
  end

  describe "GET index" do
    let(:website_order) { create(:order, store: admin_user.company, total_items: 1, admin_user: admin_user) }
    let(:offline_order)  { create(:offline_order, store: admin_user.company, total_items: 1, admin_user: admin_user, total: 13.94) }
    let(:offline_order2) { create(:offline_order, store: admin_user.company, total_items: 1, admin_user: admin_user, total: 17.94, payment_type: "installments") }

    before do
      offline_order2
      website_order and offline_order
      controller.stub(:items_per_page) { 1 }
    end

    after do
      response.should have_proper_api_headers
    end

    context "all orders" do
      it "returns the last orders" do
        xhr :get, :index

        json = ActiveSupport::JSON.decode(response.body)
        json.should == {
          "orders" => [{
            "id"          => offline_order.uuid,
            "total"       => "13.94",
            "created_at"  => offline_order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "environment" => "offline",
            "payment_type" => "cash",
            "customer_id" => offline_order.customer.uuid,
          }],
          "customers" => [{
            "id"         => offline_order.customer.uuid,
            "first_name" => offline_order.customer.first_name,
            "last_name"  => offline_order.customer.last_name,
            "email"      => offline_order.customer.email,
            "social_security_number" => offline_order.customer.social_security_number
          }],
          "meta" => {
            "page" => 1,
            "total_pages" => 2
          },
        }

        xhr :get, :index, page: 2

        json = ActiveSupport::JSON.decode(response.body)
        json.should == {
          "orders" => [{
            "id"          => offline_order2.uuid,
            "total"       => "17.94", # value for payment in installments
            "created_at"  => offline_order2.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "environment" => "offline",
            "payment_type" => "installments",
            "customer_id" => offline_order2.customer.uuid,
          }],
          "customers" => [{
            "id"         => offline_order2.customer.uuid,
            "first_name" => offline_order2.customer.first_name,
            "last_name"  => offline_order2.customer.last_name,
            "email"      => offline_order2.customer.email,
            "social_security_number" => offline_order2.customer.social_security_number
          }],
          "meta" => {
            "page" => 2,
            "total_pages" => 2
          },
        }
      end
    end

    context "specific orders" do
      it "returns the last orders" do
        xhr :get, :index, payment_type: "cash"

        json = ActiveSupport::JSON.decode(response.body)
        json.should == {
          "orders" => [{
            "id"          => offline_order.uuid,
            "total"       => offline_order.total.to_s,
            "created_at"  => offline_order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "environment" => "offline",
            "payment_type" => "cash",
            "customer_id" => offline_order.customer.uuid,
          }],
          "customers" => [{
            "id"         => offline_order.customer.uuid,
            "first_name" => offline_order.customer.first_name,
            "last_name"  => offline_order.customer.last_name,
            "email"      => offline_order.customer.email,
            "social_security_number" => offline_order.customer.social_security_number
          }],
          "meta" => {
            "page" => 1,
            "total_pages" => 1
          },
        }
      end
    end
  end

  describe "POST create" do
    after do
      response.should have_proper_api_headers
    end

    it "creates orders with embedded order items" do
      # 4 order items are created
      cart = FactoryGirl.create(:offline_cart, company: admin_user.company)
      json_request = {
        "order" => {
          "id"      => pregenerated_uuid,
          "cart_id" => cart.uuid,
          "payment_type" => "debit"
        }
      }
      xhr :post, :create, json_request

      order = Order.first
      order.uuid.should == pregenerated_uuid
      order.admin_user.should == admin_user
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "order" => {
          "id"             => order.uuid,
          "total"          => order.total.to_s,
          "created_at"     => order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
          "environment"    => "offline",
          "order_item_ids" => order.items.map(&:uuid),
          "customer_id"    => order.customer.uuid,
          "payment_type"   => "debit"
        },
        "order_items" => order.items.map { |item|
          { "id"                 => item.uuid,
            "name"               => item.name,
            "quantity"           => item.quantity,
            "price"              => item.price.to_s,
            "price_for_installments" => item.price_for_installments.to_s,
            "inventory_item_id"  => item.inventory_item.uuid,
            "order_id"           => order.uuid,
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
          { "id"                 => item.uuid,
            "name"               => item.name,
            "quantity"           => item.quantity,
            "price"              => item.price.to_s,
            "price_for_installments" => item.price_for_installments.to_s,
            "inventory_item_id"  => item.inventory_item.uuid,
            "order_id"           => order.uuid,
            "inventory_entry_id" => item.inventory_entry_id }
        )
      end
    end
  end
end

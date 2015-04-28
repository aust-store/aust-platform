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
            "links" => {
              "items" => {
                "type" => "order_items",
                "ids" => offline_order.items.map(&:uuid)
              },
              "customer" => {
                "type" => "person",
                "id" => offline_order.customer.uuid
              },
              "cart" => nil
            }
          }],
          "linked" => {
            "people" => [{
              "id"         => offline_order.customer.uuid,
              "first_name" => offline_order.customer.first_name,
              "last_name"  => offline_order.customer.last_name,
              "email"      => offline_order.customer.email,
              "social_security_number" => offline_order.customer.social_security_number
            }],
          },
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
            "links" => {
              "items" => {
                "type" => "order_items",
                "ids" => offline_order2.items.map(&:uuid)
              },
              "customer" => {
                "type" => "person",
                "id" => offline_order2.customer.uuid
              },
              "cart" => nil
            }
          }],
          "linked" => {
            "people" => [{
              "id"         => offline_order2.customer.uuid,
              "first_name" => offline_order2.customer.first_name,
              "last_name"  => offline_order2.customer.last_name,
              "email"      => offline_order2.customer.email,
              "social_security_number" => offline_order2.customer.social_security_number
            }],
          },
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
        json["orders"].should == [{
          "id"          => offline_order.uuid,
          "total"       => offline_order.total.to_s,
          "created_at"  => offline_order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
          "environment" => "offline",
          "payment_type" => "cash",
          "links" => {
            "items" => {
              "type" => "order_items",
              "ids" => offline_order.items.map(&:uuid)
            },
            "customer" => {
              "type" => "person",
              "id" => offline_order.customer.uuid,
            },
            "cart" => nil
          }
        }]

        json["linked"].should == {
          "people" => [{
            "id"         => offline_order.customer.uuid,
            "first_name" => offline_order.customer.first_name,
            "last_name"  => offline_order.customer.last_name,
            "email"      => offline_order.customer.email,
            "social_security_number" => offline_order.customer.social_security_number
          }],
        }

        json["meta"].should == {
          "page" => 1,
          "total_pages" => 1
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
      pregenerated_uuid = "53553600-c5c5-11e4-8872-455cdd00fc3b"

      json_request = {
        "orders" => {
          "id"           => pregenerated_uuid,
          "created_at"   => "Sun Mar 08 2015 16:00:02 GMT-0300 (BRT)",
          "environment"  => "offline",
          "payment_type" => "debit",
          "total"        => 193,
          "links" => {
            "order_items" => [],
            "cart"        => cart.uuid
          }
        }
      }

      Order.count.should == 0
      post :create, json_request
      Order.count.should == 1

      order = Order.last
      order.uuid.should == pregenerated_uuid
      order.admin_user.should == admin_user
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "orders" => {
          "id"             => order.uuid,
          "total"          => order.total.to_s,
          "created_at"     => order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
          "environment"    => "offline",
          "payment_type"   => "debit",
          "links" => {
            "items" => {
              "type" => "order_items",
              "ids" => order.items.map(&:uuid)
            },
            "customer" => {
              "type" => "person",
              "id" => order.customer.uuid,
            },
            "cart" => order.cart.uuid
          }
        }
      }
    end
  end
end

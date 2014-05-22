require 'spec_helper'

describe Pos::Api::CustomersController do
  include_context "an authenticable token"

  let(:admin_user) { create(:admin_user) }

  before do
    request.headers['Authorization'] = "Token token=\"#{admin_user.api_token}\""
  end

  describe "GET index" do
    after do
      response.should have_proper_api_headers
    end

    it "searches for customers with a given name" do
      customer1 = create(:customer,
                         first_name: "Luke",
                         last_name:  "Skywalker",
                         email:      "new_hope@gmail.com",
                         store:      admin_user.company)
      create(:customer, first_name: "Anakin", last_name: "Skywalker", store: admin_user.company)
      create(:customer, first_name: "Luke", last_name: "Skywalker")

      get :index, search: "luke"
      json = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "customers" => [
          { "id"         => customer1.uuid,
            "first_name" => "Luke",
            "last_name"  => "Skywalker",
            "email"      => "new_hope@gmail.com",
            "social_security_number" => "14148254393" }
        ]
      }
    end
  end

  describe "POST create" do
    after do
      response.should have_proper_api_headers
    end

    it "creates a customer" do
      json_request = {
        "customer" => {
          first_name: "John",
          last_name:  "Rambo",
          email:      "email@rambowebsite.com",
          social_security_number: "87738843403"
        }
      }
      xhr :post, :create, json_request

      customer = Person.last
      customer.first_name.should == "John"
      customer.last_name.should == "Rambo"
      customer.email.should == "email@rambowebsite.com"
      customer.social_security_number.should == "87738843403"
      customer.store.should == admin_user.company

      json  = ActiveSupport::JSON.decode(response.body)
      json.should == {
        "customer" => {
          "id"         => customer.uuid,
          "first_name" => "John",
          "last_name"  => "Rambo",
          "email"      => "email@rambowebsite.com",
          "social_security_number" => "87738843403"
        }
      }
    end

    it "creates a customer with a passed UUID" do
      pregenerated_uuid = SecureRandom.uuid
      json_request = {
        "customer" => {
          id:         pregenerated_uuid,
          first_name: "John",
          last_name:  "Rambo",
          email:      "email@rambowebsite.com",
          social_security_number: "87738843403"
        }
      }
      xhr :post, :create, json_request

      Person.last.uuid.should == pregenerated_uuid

      json  = ActiveSupport::JSON.decode(response.body)
      json.should == {
        "customer" => {
          "id"         => pregenerated_uuid,
          "first_name" => "John",
          "last_name"  => "Rambo",
          "email"      => "email@rambowebsite.com",
          "social_security_number" => "87738843403"
        }
      }
    end

    it "returns an error message when needed" do
      json_request = {
        "customer" => {
          first_name: "",
          last_name:  "",
          social_security_number: ""
        }
      }
      xhr :post, :create, json_request

      json  = ActiveSupport::JSON.decode(response.body)
      json.should == {
        "errors" => {
          "first_name" => [
            "Nome não pode ficar em branco"
          ],
        }
      }
    end
  end

  describe "PUT update" do
    after do
      response.should have_proper_api_headers
    end

    it "updates customer's attributes" do
      customer = create(:customer, store: admin_user.company)

      json_request = {
        id: customer.uuid,
        "customer" => {
          "first_name" => "Ace2",
          "last_name"  => "Ventura2",
          "email"      => "ace@ventura2.co.uk",
        }
      }
      xhr :put, :update, json_request

      customer.reload
      customer.first_name.should == "Ace2"
      customer.last_name.should == "Ventura2"
      customer.email.should == "ace@ventura2.co.uk"

      json  = ActiveSupport::JSON.decode(response.body)
      json.should == {
        "customer" => {
          "id"         => customer.uuid,
          "first_name" => "Ace2",
          "last_name"  => "Ventura2",
          "email"      => "ace@ventura2.co.uk",
          "social_security_number" => "14148254393"
        }
      }
    end

    it "returns an error message when needed" do
      customer = create(:customer, :pos, store: admin_user.company)

      json_request = {
        id: customer.uuid,
        "customer" => {
          "first_name" => "",
          "last_name"  => "",
          "email"      => "",
          "social_security_number" => ""
        }
      }
      xhr :put, :update, json_request

      json  = ActiveSupport::JSON.decode(response.body)
      json.should == {
        "errors" => {
          "first_name" => [
            "Nome não pode ficar em branco"
          ],
        }
      }
    end
  end
end

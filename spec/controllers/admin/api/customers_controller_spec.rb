require 'spec_helper'

describe Admin::Api::CustomersController do
  login_admin

  it_should_behave_like "admin application controller contract"
  it_should_behave_like "Decoration Builder contract"

  describe "GET index" do
    it "searches for customers with a given name" do
      customer1 = create(:customer,
                         first_name: "Luke",
                         last_name:  "Skywalker",
                         email:      "new_hope@gmail.com",
                         store:      @company)
      create(:customer, first_name: "Anakin", last_name: "Skywalker", store: @company)
      create(:customer, first_name: "Luke", last_name: "Skywalker")

      get :index, { search: "luke" }
      json = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "customers" => [
          { "id"         => customer1.id,
            "first_name" => "Luke",
            "last_name"  => "Skywalker",
            "email"      => "new_hope@gmail.com",
            "social_security_number" => "14148254393" }
        ]
      }
    end
  end

  describe "POST create" do
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

      customer = Customer.last
      customer.first_name.should == "John"
      customer.last_name.should == "Rambo"
      customer.email.should == "email@rambowebsite.com"
      customer.social_security_number.should == "87738843403"
      customer.store.should == @company

      json  = ActiveSupport::JSON.decode(response.body)
      json.should == {
        "customer" => {
          "id"         => customer.id,
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
          "last_name" => [
            "Sobrenome não pode ficar em branco"
          ],
          "social_security_number" => [
            "O campo CPF não pode ficar em branco!",
          ]
        }
      }
    end
  end

  describe "PUT update" do
    it "updates customer's attributes" do
      customer = FactoryGirl.create(:customer, store: @company)

      json_request = {
        id: customer.id,
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
          "id"         => customer.id,
          "first_name" => "Ace2",
          "last_name"  => "Ventura2",
          "email"      => "ace@ventura2.co.uk",
          "social_security_number" => "14148254393"
        }
      }
    end
  end
end

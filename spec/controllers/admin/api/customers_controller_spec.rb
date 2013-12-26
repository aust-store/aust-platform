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

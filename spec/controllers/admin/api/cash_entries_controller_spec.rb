require 'spec_helper'

describe Admin::Api::CashEntriesController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  it_behaves_like "an api endpoint with date search", :cash_entries, :cash_entry
  it_behaves_like "an api endpoint returning only own user resources", :cash_entries, :cash_entry

  let(:pregenerated_uuid) { SecureRandom.uuid }

  describe "GET index" do
    let(:cash1) { create(:cash_entry, company: @company, admin_user: @admin_user) }
    let(:cash2) { create(:cash_entry, company: @company, admin_user: @admin_user) }

    before do
      cash1 and cash2
      controller.stub(:items_per_page) { 1 }
    end

    it "returns all resources" do
      xhr :get, :index

      ActiveSupport::JSON.decode(response.body).should == {
        "cash_entries" => [{
          "id"    => cash2.uuid,
          "amount" => cash2.amount.to_s,
          "entry_type" =>  "addition",
          "description" => cash2.description,
          "created_at" => json_datetime(cash2.created_at)
        }],
        "meta" => {
          "page" => 1,
          "total_pages" => 2
        }
      }

      xhr :get, :index, page: 2

      ActiveSupport::JSON.decode(response.body).should == {
        "cash_entries" => [{
          "id"    => cash1.uuid,
          "amount" => cash1.amount.to_s,
          "entry_type" =>  "addition",
          "description" => cash1.description,
          "created_at" => json_datetime(cash1.created_at)
        }],
        "meta" => {
          "page" => 2,
          "total_pages" => 2
        }
      }
    end
  end

  describe "POST create" do
    it "creates a cash entry" do
      request_json = {
        cash_entry: {
          id: pregenerated_uuid,
          amount: 10.2,
          entry_type:  "addition",
          description: "First cash in the day",
          created_at: "Thu Jan 27 2014 23:58:15 GMT-0200 (BRST)"
        }
      }
      xhr :post, :create, request_json

      cash_entry = PosCashEntry.first
      cash_entry.uuid.should == pregenerated_uuid
      cash_entry.company.should == @company
      cash_entry.admin_user.should == @admin_user
      cash_entry.created_at.utc.should == Time.parse(request_json[:cash_entry][:created_at]).utc

      json = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "cash_entry" => {
          "id"    => pregenerated_uuid,
          "amount" => "10.2",
          "description" => "First cash in the day",
          "entry_type" =>  "addition",
          "created_at" => date_match(cash_entry.created_at, 2014, 01, 27, 23, 58, 15)
        }
      }
    end

    it "creates a subtraction cash entry" do
      request_json = {
        cash_entry: {
          id: pregenerated_uuid,
          amount: 5000,
          entry_type:  "subtraction",
          description: nil,
          created_at: "Thu Jan 27 2014 23:58:15 GMT-0200 (BRST)"
        }
      }
      xhr :post, :create, request_json

      cash_entry = PosCashEntry.first
      cash_entry.uuid.should == pregenerated_uuid
      cash_entry.company.should == @company
      cash_entry.admin_user.should == @admin_user
      cash_entry.created_at.utc.should == Time.utc.parse(request_json[:cash_entry][:created_at])

      json = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "cash_entry" => {
          "id"    => pregenerated_uuid,
          "amount" => "5000.0",
          "entry_type" =>  "subtraction",
          "description" => nil,
          "created_at" => date_match(cash_entry.created_at, 2014, 01, 27, 23, 58, 15)
        }
      }
    end
    it "creates an invalid cash entry" do
      request_json = {
        cash_entry: {
          id: pregenerated_uuid,
          amount: 10.2,
          #entry_type:  "addition",
          description: "First cash in the day",
          #created_at: "Thu Jan 27 2014 23:58:15 GMT-0200 (BRST)"
        }
      }
      xhr :post, :create, request_json

      PosCashEntry.count.should == 0

      json = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "entry_type" => [
          "Tipo de registro de dinheiro no caixa inválido"
        ]
      }
    end
  end

  describe "PUT update" do
    let(:cash_entry) { create(:cash_entry, company: @company, admin_user: @admin_user) }

    before do
      cash_entry
    end

    it "updates the cash entry" do
      xhr :put, :update, {
        id: cash_entry.uuid,
        cash_entry: {
          amount: 28.9,
          description: "ssssss"
        }
      }

      json = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "cash_entry" => {
          "id"    => cash_entry.uuid,
          "amount" => "28.9",
          "entry_type" =>  "addition",
          "description" => "ssssss",
          "created_at" => json_datetime(cash_entry.created_at)
        }
      }
    end
  end
end

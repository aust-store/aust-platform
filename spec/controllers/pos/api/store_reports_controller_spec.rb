require 'spec_helper'

describe Pos::Api::StoreReportsController do
  include_context "an authenticable token"

  let(:admin_user) { create(:admin_user) }

  before do
    request.headers['Authorization'] = "Token token=\"#{admin_user.api_token}\""
  end

  describe "GET show" do
    let(:today_offline_order) { create(:offline_order, store: admin_user.company, total_items: 2, total: 20) }
    let(:today_offline_order2) { create(:offline_order, store: admin_user.company, total_items: 2, total: 35, payment_type: "installments") }

    before do
      Timecop.travel(Time.utc(2013, 8, 10, 10, 10, 10)) do
        create(:order, store: admin_user.company, total_items: 1)
        create(:order, store: nil, total_items: 1)
      end

      Timecop.travel(Time.utc(2013, 10, 10, 10, 10, 10)) do
        today_offline_order
        today_offline_order2
      end
    end

    after do
      response.should have_proper_api_headers
    end

    context "default request" do
      before do
        Timecop.travel(Time.utc(2013, 10, 10, 10, 10, 10)) do
          get :show
        end
      end

      it "returns the all-time statistics" do
        json = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "store_reports" => [{
            "id" => "today_offline",
            "period" => "today",
            "environment" => "offline",
            "revenue" => "55.0"
          }]
        }
      end
    end
  end
end


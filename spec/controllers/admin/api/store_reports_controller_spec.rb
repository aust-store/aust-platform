require 'spec_helper'

describe Admin::Api::StoreReportsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET show" do
    let(:today_offline_order) { create(:offline_order, store: @company, total_items: 2) }

    before do
      Timecop.travel(Time.utc(2013, 8, 10, 10, 10, 10)) do
        create(:order, store: @company, total_items: 1)
        create(:order, store: nil, total_items: 1)
      end

      Timecop.travel(Time.utc(2013, 10, 10, 10, 10, 10)) do
        today_offline_order
      end
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
            "revenue" => "27.88"
          }]
        }
      end
    end
  end
end


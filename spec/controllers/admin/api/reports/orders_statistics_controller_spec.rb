require 'spec_helper'

describe Admin::Api::Reports::OrdersStatisticsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET show" do
    before do
      Timecop.travel(Time.local(2013, 8, 10, 10, 10, 10)) do
        FactoryGirl.create(:order, store: @company, total_items: 1)
        FactoryGirl.create(:order, store: nil, total_items: 1)
      end

      Timecop.travel(Time.local(2013, 10, 10, 10, 10, 10)) do
        FactoryGirl.create(:order, store: @company, total_items: 2)
      end
    end

    context "default request" do
      before do
        Timecop.travel(Time.local(2013, 10, 10, 10, 10, 10)) do
          get :show
        end
      end

      it "returns the all-time statistics", focus: true do
        json = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "orders_statistics" => [{
            "revenue" => "41.82"
          }]
        }
      end
    end

    context "specifying a period option" do
      before do
        Timecop.travel(Time.local(2013, 10, 10, 15, 10, 10)) do
          get :show, period: "today"
        end
      end

      it "returns the all-time statistics " do
        json = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "orders_statistics" => [{
            "revenue" => "27.88"
          }]
        }
      end
    end
  end
end


# encoding: utf-8
require 'acceptance_spec_helper'

feature "Statistics" do

  background do
    login_into_admin

    # 2 months ago
    Timecop.travel(Time.local(2013, 8, 10, 10, 10, 10)) do
      FactoryGirl.create(:order, store: @company, total_items: 1)
      FactoryGirl.create(:order, store: nil, total_items: 1)
    end

    # less than a month ago
    Timecop.travel(Time.local(2013, 9, 12, 10, 10, 10)) do
      items = [
        FactoryGirl.create(:order_item_without_associations, price: 1.0)
      ]
      FactoryGirl.create(:order, store: @company, items: items)
      FactoryGirl.create(:order, store: nil, total_items: 1)
    end

    # yesterday
    Timecop.travel(Time.local(2013, 10, 9, 10, 10, 10)) do
      items = [
        FactoryGirl.create(:order_item_without_associations, price: 10.0),
        FactoryGirl.create(:order_item_without_associations, price: 10.0)
      ]
      FactoryGirl.create(:order, store: @company, items: items)
    end

    # today
    Timecop.travel(Time.local(2013, 10, 10, 10, 10, 10)) do
      items = [
        FactoryGirl.create(:order_item_without_associations, price: 12.0),
        FactoryGirl.create(:order_item_without_associations, price: 12.0)
      ]
      FactoryGirl.create(:order, store: @company, items: items, total: 24)
    end

    visit admin_reports_path
  end

  describe "As a admin" do
    scenario "I see sales reports" do
      Order.last.total.should == 24.0

      Timecop.travel(Time.local(2013, 10, 10, 15, 10, 10)) do
        click_on "sales_reports"
        page.should have_content "Vendas hoje: R$ 24,00"
        page.should have_content "Vendas este mês: R$ 44,00"
        page.should have_content "Vendas últimos 30 dias: R$ 45,00"
      end
    end
  end
end

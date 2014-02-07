# encoding: utf-8
require 'acceptance_spec_helper'

feature "Orders Management" do
  before do
    login_into_admin
    stub_subdomain(@company)
    @item = FactoryGirl.create(:inventory_item, user: @admin_user, company: @company)
  end

  describe "the index page" do
    before do
      Timecop.travel(Time.utc(2013, 03, 30, 10, 10, 10)) do
        @pending_order = FactoryGirl.create(:order, store: @company, total: 41.82, total_items: 3)
        @paid_order    = FactoryGirl.create(:paid_order, store: @company, total: 69.70, total_items: 5)
      end
    end

    scenario "As a store admin, I want to see the basic item's details" do
      visit admin_orders_path

      within "#order_card_#{@pending_order.id}" do
        within(".shipping_status") { page.should have_content "" }
        within(".payment_status")  { page.should have_content "Aguardando pgto." }
        within(".items_quantity")  { page.should have_content "3 itens" }
        within(".total")           { page.should have_content "R$ 41,82" }
        within(".purchase_date")   { page.should have_content "30/03/2013 07:10" }
      end

      within "#order_card_#{@paid_order.id}" do
        within(".shipping_status") { page.should have_content "Itens enviados" }
        within(".payment_status")  { page.should have_content "Pagamento Completo" }
        within(".items_quantity")  { page.should have_content "5 itens" }
        within(".total")           { page.should have_content "R$ 69,70" }
        within(".purchase_date")   { page.should have_content "30/03/2013 07:10" }
      end
    end
  end
end

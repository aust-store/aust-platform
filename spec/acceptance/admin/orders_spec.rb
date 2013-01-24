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
      @pending_order = FactoryGirl.create(:order, store: @company)
      @paid_order    = FactoryGirl.create(:paid_order, store: @company)
    end

    scenario "As a store admin, I want to see the basic item's details" do
      visit admin_orders_path

      within "#order_card_#{@pending_order.id}" do
        page.should have_content "Aguardando pgto."
        page.should have_content "R$ 55,76"
        page.should have_content @pending_order.created_at.strftime("%d/%m/%Y %H:%M")
        page.should have_content "4 itens"
      end

      within "#order_card_#{@paid_order.id}" do
        page.should have_content "Pagamento Completo"
        page.should have_content "Itens enviados"
        page.should have_content "R$ 55,76"
        page.should have_content @paid_order.created_at.strftime("%d/%m/%Y %H:%M")
        page.should have_content "4 itens"
      end
    end
  end
end

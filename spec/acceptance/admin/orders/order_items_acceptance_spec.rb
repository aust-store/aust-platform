# encoding: utf-8
require 'acceptance_spec_helper'

feature "Orders Management" do
  before do
    stub_shipping
    stub_correios
    @company = FactoryGirl.create(:company_with_zipcode)
    stub_subdomain(@company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
  end

  describe "the index page" do
    scenario "As a store admin, I want to see different status to the same item" do
      visit cart_path
      # cart status at the top of the page
      within ".cart_status" do
        page.should have_content "Seu carrinho está vazio."
      end

      inventory_entry = @product.balances.first

      3.times do
        visit product_path(inventory_entry)
        click_link "Adicionar ao carrinho"
      end

      page.should have_content "Goodyear"

      OrderItem.count.should == 3

      within ".cart_status" do
        page.should have_content "Você possui 3 itens no carrinho."
      end

      order_item_id = OrderItem.parent_items.first.id
      fill_in "cart[item_quantities][#{order_item_id}]", with: "4"
      click_button "Atualizar carrinho"

      OrderItem.count.should == 4

      within ".items_total .total_price" do
        page.should have_content "R$ 49,36" # 4 x R$ 12,34
      end

      #admin
      order_items = OrderItem.all
      login_into_admin

      order = FactoryGirl.create(:order, store_id: @company.id)
      order.items.destroy_all
      order_items.each { |item| order.items << item }
      order.save

      visit admin_order_path(order)
      select "Enviado", from: "order_items_attributes_0_status"

      click_button "Atualizar pedido"
      visit admin_dashboard_path

      visit admin_order_path(order)
      page.should have_select("order_items_attributes_0_status", selected: "Enviado")
    end
  end
end

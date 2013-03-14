# encoding: utf-8
require 'acceptance_spec_helper'

feature "Orders Management" do
  before do
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
      Timecop.travel(Time.local(2012, 04, 20, 10, 0, 0)) do
        visit product_path(inventory_entry)
        click_link "Adicionar ao carrinho"
      end

      Timecop.travel(Time.local(2012, 04, 21, 10, 0, 0)) do
        visit product_path(inventory_entry)
        click_link "Adicionar ao carrinho"
      end

      Timecop.travel(Time.local(2012, 04, 22, 10, 0, 0)) do
        visit product_path(inventory_entry)
        click_link "Adicionar ao carrinho"
      end

      order_items = OrderItem.all

      page.should have_content "Goodyear"

      OrderItem.count.should == 3

      # cart status at the top of the page
      within ".cart_status" do
        page.should have_content "Você possui 3 itens no carrinho."
      end

      # then
      #
      # changes the quantity
      order_item_id = OrderItem.where(related_id: nil).first.id
      fill_in "cart[item_quantities][#{order_item_id}]", with: "4"
      click_button "Atualizar carrinho"

      OrderItem.count.should == 4

      order_items = OrderItem.all


      # quantity field has a 3
      
      #find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "3"
      
      # price
      within ".items_total .total_price" do
        page.should have_content "R$ 49,36" # 4 x R$ 12,34
      end

      login_into_admin

      order = FactoryGirl.create(:order, store_id: @company.id)
      order.items.destroy_all
      order_items.each { |item| order.items << item }
      order.save

      visit admin_order_path(order.id)

      within "table.listing" do
        page.should have_content "Goodyear"
      end

      puts OrderItem.all.each { |item| puts item.status }
      
      select "Enviado", from: "order_items_attributes_#{order.items.first.id}_status"
      
      click_button "Atualizar pedido"

      puts Order.all.each { |order| puts order.items.inspect  }
      puts "=============="

      order.save

      puts order.items.each { |item| puts item.status }

      save_and_open_page
    end
  end
end

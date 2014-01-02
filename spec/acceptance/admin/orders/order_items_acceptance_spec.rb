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

      3.times do
        visit product_path(@product)
        click_link I18n.t("store.products.show.add_to_cart_link")
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
      Order.all
      OrderItem.all

      option_tags = []
      all("#order_items_attributes_0_status").each do |result|
        option_tags << result.text
      end
      if option_tags.join("") != "PendenteEnviadoCancelado"
        puts "option tags' text: #{option_tags.join("")}"
        puts "orders: #{Order.all.inspect}"
        puts "orders items: #{OrderItem.all.inspect}"
        save_and_open_page
      end

      all("#order_items_attributes_0_status option")[0].should_not be_selected
      all("#order_items_attributes_0_status option")[1].should be_selected
      all("#order_items_attributes_0_status option")[2].should_not be_selected
    end
  end
end

# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  before do
    stub_correios
    @company = FactoryGirl.create(:company_with_zipcode)
    stub_subdomain(@company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
  end

  context "an empty cart" do
    scenario "As an user, I can see an appropriate message when the cart is empty" do
      visit cart_path

      page.should have_content "Seu carrinho está vazio."
    end
  end

  describe "item quantities management" do
    scenario "As an user, I see the correct price and quantity of an item in " + \
             "my cart, then I can change the quantities and later remove " + \
             "them" do

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

      OrderItem.count.should == 1
      page.should have_content "Goodyear"

      # cart status at the top of the page
      within ".cart_status" do
        page.should have_content "Você possui 3 itens no carrinho."
      end

      # quantity field has a 3
      order_item_id = OrderItem.first.id
      find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "3"

      # price
      within ".items_total .total_price" do
        page.should have_content "R$ 37,02" # 3 x R$ 12,34
      end

      # then
      #
      # changes the quantity
      fill_in "cart[item_quantities][#{order_item_id}]", with: "4"
      click_button "Atualizar carrinho"

      # the quantity was changed
      find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "4"

      # price was changed
      within ".items_total .total_price" do
        page.should have_content "R$ 49,36"
      end

      # cart status at the top of the page
      within ".cart_status" do
        page.should have_content "Você possui 4 itens no carrinho."
      end

      # deletes an item
      within(".order_item_#{order_item_id}") do
        find("[name='remove_order_item']").click
      end

      page.should_not have_content "Goodyear"
    end
  end

  describe "shipping calculations", js: true do
    scenario "As an user, I enter my zipcode to calculate the shipping price" do
      stub_shipping

      inventory_entry = @product.balances.first
      visit product_path(inventory_entry)
      click_link "Adicionar ao carrinho"

      within(".js_service_selection") do
        choose("type_pac")
      end
      fill_in "zipcode", with: "96360000"

      page.should have_content "R$ 12,34"
      page.should have_content "entrega em 3 dias úteis"
    end

    scenario "As an user, I see a message when shipping is not available" do
      @company.settings.update_attributes(zipcode: "")

      inventory_entry = @product.balances.first
      visit product_path(inventory_entry)

      click_link "Adicionar ao carrinho"

      page.should have_content "#{I18n.t("store.cart.show.shipping_disabled_message")}"
    end
  end

  describe "policies" do
    background do
      inventory_entry = @product.balances.first
      visit product_path(inventory_entry)
      click_link "Adicionar ao carrinho"
    end

    scenario "As an user, I can see a checkout button if a payment gateway was configured" do
      visit cart_path
      page.should have_selector "#checkout_button"
    end

    scenario "As an user, I can't see a checkout button if not payment gateway was configured" do
      @company.payment_gateway.delete
      visit cart_path
      page.should_not have_selector "#checkout_button"
    end
  end
end

# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  before do
    stub_correios
    @company = FactoryGirl.create(:company_with_zipcode, handle: "mystore")
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

      stub_shipping
      visit cart_path
      # cart status at the top of the page
      within ".cart_status" do
        page.should have_content "Seu carrinho está vazio."
      end

      3.times do
        visit product_path(@product)
        click_link I18n.t("store.products.show.add_to_cart_link")
      end

      OrderItem.count.should == 3
      page.should have_content "Goodyear"

      # cart status at the top of the page
      within ".cart_status" do
        page.should have_content "Você possui 3 itens no carrinho."
      end

      # quantity field has a 3
      order_item_id = OrderItem.order('id asc').first.id
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

  describe "shipping calculations" do
    scenario "As an user, my shipping price is calculated as I type my zipcode", js: true do
      stub_shipping

      visit product_path(@product)
      click_link I18n.t("store.products.show.add_to_cart_link")

      within(".js_service_selection") do
        choose("type_pac")
      end
      fill_in "zipcode", with: "96360000"

      page.should have_content "R$ 111,23"
      page.should have_content "entrega em 3 dias úteis"
    end

    scenario "As an user, I see a message when shipping is not available" do
      @company.settings.update_attributes(zipcode: "")
      visit product_path(@product)

      click_link I18n.t("store.products.show.add_to_cart_link")

      page.should have_content "#{I18n.t("store.cart.show.shipping_disabled_message")}"
    end

    scenario "As an user, I can update the shipping cost by clicking the update button" do
      stub_shipping
      visit product_path(@product)
      click_link I18n.t("store.products.show.add_to_cart_link")

      page.should_not have_content "R$ 111,23"
      page.should_not have_content "entrega em 3 dias úteis"

      within(".js_service_selection") { choose("type_pac") }
      fill_in "zipcode", with: "96360000"
      click_button "update_cart"

      page.should have_content "R$ 111,23"
      page.should have_content "entrega em 3 dias úteis"
    end
  end

  describe "Policies" do
    describe "cart page" do
      background do
        visit product_path(@product)
        click_link I18n.t("store.products.show.add_to_cart_link")
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

    describe "links to cart" do
      scenario "As an user, I can't see cart links if sales are disabled" do
        CompanySetting.first.update_attributes(sales_enabled: "0")
        visit root_path
        page.should_not have_selector "#path_to_cart"
        page.should_not have_content "Seu carrinho"

        visit cart_path
        current_path.should == root_path
      end
    end
  end
end

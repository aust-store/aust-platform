# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  before do
    @company = FactoryGirl.create(:company)
    stub_subdomain(@company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
  end

  describe "an empty cart" do
    scenario "As an user, I can see an appropriate message when the cart is empty" do
      visit cart_path

      page.should have_content "Seu carrinho está vazio."
    end
  end

  describe "item quantities management" do
    scenario "As an user, I see the correct quantity of an item in my cart,  " + \
             "then I can change the quantities and later remove them" do

      inventory_entry = @product.balances.first
      3.times do
        visit product_path(inventory_entry)
        click_link "Adicionar ao carrinho"
      end

      OrderItem.count.should == 1
      page.should have_content "Goodyear"

      order_item_id = OrderItem.first.id
      find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "3"

      # changes the quantity
      fill_in "cart[item_quantities][#{order_item_id}]", with: "4"
      click_button "Atualizar carrinho"

      # the quantity was changed
      find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "4"

      # deletes an item
      within(".order_item_#{order_item_id}") do
        find("[name='remove_order_item']").click
      end

      page.should_not have_content "Goodyear"
    end
  end

  describe "shipping calculations", js: true do
    let(:stubbed_shipping) { double(success?: true, total: 12.34, days: 3) }

    scenario "As an user, I enter my zipcode to calculate the shipping price" do
      Store::Shipping::CartCalculation.stub(:create) { stubbed_shipping }

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
  end
end

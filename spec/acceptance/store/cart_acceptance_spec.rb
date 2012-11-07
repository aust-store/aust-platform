# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  before do
    @company = FactoryGirl.create(:company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
  end

  describe "an empty cart" do
    scenario "As an user, I can see an appropriate message when the cart is empty" do
      visit store_cart_path(@company.handle)

      page.should have_content "Seu carrinho está vazio."
    end
  end

  describe "item quantities management" do
    scenario "As an user, I see the correct quantity of an item in my cart,  " + \
             "then I can change the quantities and later remove them" do

      inventory_entry = @product.balances.first
      3.times do
        visit store_product_path(@company.handle, inventory_entry)
        click_link "Comprar"
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
end

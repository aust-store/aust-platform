# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  before do
    @company = FactoryGirl.create(:company)
    @product = FactoryGirl.create(:good, company: @company)
  end

  describe "an empty cart" do
    scenario "As an user, I can see an appropriate message when the cart is empty" do
      visit store_cart_path(@company.handle)

      page.should have_content "Seu carrinho está vazio."
    end
  end

  describe "item quantities management" do
    scenario "As an user, I see the correct quantity of an item in my cart" do
      3.times do
        visit store_product_path(@company.handle, @product.balances.first)
        click_link "Comprar"
      end

      within ".product_0" do
        find(".quantity").find("input").value.should == "3"
      end
      page.should_not have_selector ".product_1"
    end

    scenario "As an user, I remove items by changing the quantity field", wip: true do
      3.times do
        visit store_product_path(@company.handle, @product.balances.first)
        click_link "Comprar"
      end

      order_item_id = OrderItem.first.id

      fill_in "cart[item_quantities][#{order_item_id}]", with: "4"
      click_button "Atualizar carrinho"

      find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "4"
    end
  end
end

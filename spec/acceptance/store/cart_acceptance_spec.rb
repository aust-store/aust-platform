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
end

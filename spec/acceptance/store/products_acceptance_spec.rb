require "acceptance_spec_helper"

feature "Store products" do
  before do
    @company = FactoryGirl.create(:company)
    @product = FactoryGirl.create(:good, company: @company)
  end

  describe "products details" do
    scenario "As an user, I can see a products' details" do
      visit store_product_path(@company.handle, @product.balances.first)

      page.should have_content @product.name
    end
  end

  describe "adding a product to the cart" do
    scenario "As an user, I can add a product to the cart" do
      visit store_product_path(@company.handle, @product.balances.first)

      click_link "Comprar"
      current_path.should == store_cart_path(@company)
      page.should have_content @product.name
    end
  end
end

require "acceptance_spec_helper"

feature "Store products" do
  before do
    inventory_entry_one = FactoryGirl.create(:inventory_entry, price: 11.0)
    @company = FactoryGirl.create(:company)
    stub_subdomain(@company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
    stub_shipping_calculation_enabled(true)
  end

  describe "products details" do
    scenario "As an user, I can see a products' details" do
      visit product_path(@product.balances.first)

      page.should have_content @product.name
      page.should have_content @product.merchandising
      page.should have_content @product.description
      page.should have_content "R$ 20,00"
      page.should have_content @product.images.first.image
      page.should have_content @product.images.last.image

      click_link "Adicionar ao carrinho"
      current_path.should == cart_path
      page.should have_content @product.name

    end
  end

  describe "adding a product to the cart" do
    scenario "As an user, I can add a product to the cart" do
      visit product_path(@product.balances.first)

      click_link "Adicionar ao carrinho"
      current_path.should == cart_path
      page.should have_content @product.name
    end
  end
end

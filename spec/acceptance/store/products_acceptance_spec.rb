require "acceptance_spec_helper"

feature "Store products" do
  before do
    stub_correios
    @company = FactoryGirl.create(:company_with_zipcode)
    stub_subdomain(@company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
  end

  describe "products details" do
    scenario "As an user, I can see a products' details" do
      visit product_path(@product)

      page.should have_content @product.name
      page.should have_content @product.merchandising
      page.should have_content @product.description
      page.should have_content "R$ 12,34"
      page.should have_content @product.images.first.image
      page.should have_content @product.images.last.image

      click_link I18n.t("store.products.show.add_to_cart_link")
      current_path.should == cart_path
      page.should have_content @product.name

    end
  end

  describe "adding a product to the cart" do
    scenario "As an user, I can add a product to the cart" do
      entry_in_cart = @product.entries.first
      visit product_path(@product)

      click_link I18n.t("store.products.show.add_to_cart_link")
      current_path.should == cart_path
      page.should have_content @product.name

      # The id used in the product page to add to the cart the inventory_entry
      OrderItem.first.inventory_entry_id.should == entry_in_cart.id
    end
  end
end

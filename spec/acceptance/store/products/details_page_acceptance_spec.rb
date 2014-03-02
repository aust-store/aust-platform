require "acceptance_spec_helper"

feature "Store/Products details page" do
  before do
    stub_correios
    @company = FactoryGirl.create(:company_with_zipcode, :minimalism_theme)
    stub_subdomain(@company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
  end

  scenario "As an user, I see a products' details page with information" do
    CompanySetting.first.update_attributes(sales_enabled: "1")
    visit product_path(@product)

    page.should have_content @product.name
    page.should have_content @product.merchandising
    page.should have_content @product.description
    page.should have_content "R$ 12,34"
    page.should have_content @product.images.first.image
    page.should have_content @product.images.last.image
    page.should have_content "Seu carrinho está vazio."

    click_link "add_to_cart"
    page.should have_selector "#path_to_cart"
    current_path.should == cart_path
    page.should have_content @product.name
  end

  describe "As an user wishing to add a product to cart" do
    scenario "I can add it if everything's fine" do
      entry_in_cart = @product.entries.first
      visit product_path(@product)

      page.should have_selector "#add_to_cart"
      click_link I18n.t("store.products.show.add_to_cart_link")
      current_path.should == cart_path
      page.should have_content @product.name

      # The id used in the product page to add to the cart the inventory_entry
      OrderItem.first.inventory_entry_id.should == entry_in_cart.id
    end

    scenario "I can't add it if global sales are disabled" do
      CompanySetting.first.update_attributes(sales_enabled: "0")
      visit product_path(@product)
      page.should_not have_selector "#add_to_cart"
    end

    context "shipping box" do
      scenario "I can't add it if product doesn't have a shipping box defined" do
        @product.shipping_box = nil
        @product.save
        visit product_path(@product)
        page.should_not have_selector "#add_to_cart"
      end

      scenario "I can't add it if shipping box is invalid" do
        @product.shipping_box.update_attribute(:width, 1)
        @product.reload
        visit product_path(@product)
        page.should_not have_selector "#add_to_cart"
      end
    end
  end
end

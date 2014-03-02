require "acceptance_spec_helper"

feature "Store/Products in home page" do
  let(:company) { create(:company_with_zipcode, :minimalism_theme) }
  let(:product) { create(:inventory_item, company: company) }

  before do
    stub_correios
    stub_subdomain(company)
    product
  end

  scenario "As an user, I see a product in the homepage" do
    visit root_path
    page.should have_content product.name
  end

  describe "As user in the homepage" do
    context "visible products" do
      scenario "I see the product when global sales are disabled" do
        CompanySetting.first.update_attributes(sales_enabled: "0")
        visit root_path
        page.should have_content product.name
      end

      scenario "I see a product with an invalid shipping box" do
        product.shipping_box = nil
        product.save
        visit root_path
        page.should have_content product.name
      end
    end

    describe "invisible products" do
      scenario "I can't see items without entries for website sale" do
        product.entries.each { |e| e.update_attributes(website_sale: false) }
        visit root_path
        page.should_not have_content product.name
      end

      scenario "I can't see items without a cover image" do
        product.images.cover.update_all(cover: false)
        visit root_path
        page.should_not have_content product.name
      end
    end
  end
end

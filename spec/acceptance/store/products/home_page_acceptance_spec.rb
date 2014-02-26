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

  describe "edge cases" do
    context "As user in the homepage" do
      scenario "I can see the product when global sales are disabled" do
        CompanySetting.first.update_attributes(sales_enabled: "0")
        visit root_path
        page.should have_content product.name
      end
    end
  end
end

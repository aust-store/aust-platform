require "acceptance_spec_helper"

feature "Static pages" do
  before do
    @company = FactoryGirl.create(:company_with_zipcode)
    stub_subdomain(@company)
    @page = FactoryGirl.create(:page, company_id: @company.id)
  end

  scenario "As an user, I can see a products' details" do
    visit root_path

    within "#navigation" do
      page.should have_content @page.title
      click_link @page.title
    end

    page.should have_content @page.title
    page.should have_content @page.body
  end
end

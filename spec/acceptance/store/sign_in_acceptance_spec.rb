require "acceptance_spec_helper"

feature "Store Sign In" do
  before do
    @company = FactoryGirl.create(:company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
    stub_subdomain(@company)
  end

  scenario "As an user, I can access a sign in form and go " + \
           "to the sign up page", js: true do
    visit new_user_session_path

    page.should have_selector "#user_email"
    page.should have_selector "#user_password"
    page.should have_selector "#sign_in"

    fill_in "user_email", with: "user@example.com"
    choose("has_no_password")
    click_on "sign_in"
    expect(current_path).to eq(new_user_registration_path)
  end
end

require 'acceptance_spec_helper'

feature "Admin User registration", js: true do

  scenario "As a user, I'd like to register a new store" do
    visit new_admin_user_registration_path

    page.should have_selector "input#admin_user_email"
    page.should have_selector "input#admin_user_password"
    page.should have_selector "input#admin_user_password_confirmation"
    page.should have_selector "input#admin_user_company_attributes_name"

    fill_in "admin_user_email", with: "admin_user@example.com"
    fill_in "admin_user_password", with: "123456"
    fill_in "admin_user_password_confirmation", with: "123456"
    fill_in "admin_user_company_attributes_name", with: "Petshop Store"
    fill_in "handle", with: "mypet"

    page.should have_content "http://mypet.store.com"

    click_button "sign_up"

    current_path.should == admin_dashboard_path
    AdminUser.find_by_email("admin_user@example.com").should be_true
    Company.find_by_name("Petshop Store").inventory.should be_true
    Company.find_by_handle("mypet").should be_true

    page.should_not have_content "You have signed up successfully."
  end
end

require 'spec_helper'

feature "Admin User registration" do

  scenario "As a user, I'd like to register a new store" do
    visit new_admin_user_registration_url

    page.should have_selector "input#admin_user_email"
    page.should have_selector "input#admin_user_password"
    page.should have_selector "input#admin_user_password_confirmation"
    page.should have_selector "input#admin_user_company_attributes_name"

    fill_in "admin_user_email", with: "admin_user@example.com"
    fill_in "admin_user_password", with: "123456"
    fill_in "admin_user_password_confirmation", with: "123456"
    fill_in "admin_user_company_attributes_name", with: "Petshop Store"

    click_button "Sign up"

    AdminUser.find_by_email("admin_user@example.com").should be_true
    Company.find_by_name("Petshop Store").inventory.should be_true

    current_path.should == admin_dashboard_path

    page.should_not have_content "You have signed up successfully."
  end
end
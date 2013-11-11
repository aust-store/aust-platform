require 'acceptance_spec_helper'

feature "Store Subscription" do
  scenario "As a user, I'd like to register a new store", js: true do
    visit subscription_path

    # Page 1
    #
    # A user must define a company name and a subdomain
    page.should have_selector "input#admin_user_name"
    page.should have_selector "input#admin_user_email"
    page.should have_selector "input#admin_user_password"
    page.should have_selector "input#admin_user_password_confirmation"
    page.should have_selector "input#company_name"

    fill_in "admin_user_name", with: "admin_user"
    fill_in "admin_user_email", with: "admin_user@example.com"
    fill_in "admin_user_password", with: "123456"
    fill_in "admin_user_password_confirmation", with: "123456"
    fill_in "company_name", with: "Petshop Store"
    fill_in "handle", with: "mypet"

    page.should have_content "http://mypet.store.com"

    click_button "create_account"

    # Dashboard
    #
    # Last step is finished
    current_path.should == admin_dashboard_path
    admin_user = AdminUser.where(email: "admin_user@example.com").first
    admin_user.should be_true
    admin_user.name.should == "admin_user"
    admin_user.role.should == "founder"
    Company.where(name: "Petshop Store").first.inventory.should be_true
    Company.where(handle: "mypet").to_a.should be_true

    page.should_not have_content "You have signed up successfully."
  end
end

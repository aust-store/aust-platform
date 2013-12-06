require 'acceptance_spec_helper'

feature "Store Subscription" do
  background do
    create(:theme, :minimalism)
  end

  scenario "As a user, I'd like to register a new store", js: true do
    pending "with session_store having domain: :all, Devise won't work because o CSRF problems"
    visit subscription_path

    # Page 1
    #
    # A user must define a company name and a subdomain
    page.should have_selector "input#admin_user_name"
    page.should have_selector "input#admin_user_email"
    page.should have_selector "input#admin_user_password"
    page.should have_selector "input#admin_user_password_confirmation"
    page.should have_selector "input#company_name"

    fill_in_fields

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

    company = Company.where(handle: "mypet").first
    company.name.should == "Petshop Store"
    company.inventory.should be_present

    page.should_not have_content "You have signed up successfully."
  end

  scenario "As an user after creating a store, the default theme is minimalism" do
    visit subscription_path
    fill_in_fields
    click_button "create_account"

    theme = Company.where(handle: "mypet").first.theme
    theme.name.should == "Minimalism"
    theme.path.should == "minimalism"
  end

  def fill_in_fields
    fill_in "admin_user_name", with: "admin_user"
    fill_in "admin_user_email", with: "admin_user@example.com"
    fill_in "admin_user_password", with: "123456"
    fill_in "admin_user_password_confirmation", with: "123456"
    fill_in "company_name", with: "Petshop Store"
    fill_in "handle", with: "mypet"
  end
end

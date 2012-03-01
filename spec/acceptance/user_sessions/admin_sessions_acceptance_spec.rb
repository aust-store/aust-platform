require 'spec_helper'

feature "Admin User sessions", js: true do
  before do
    @admin_user = Factory(:admin_user)
  end

  scenario "As a user, I'd like to sign in into my store admin" do
    visit "/admin_users/sign_in"

    within("form#new_admin_user") do
      fill_in "admin_user_email", with: @admin_user.email
      fill_in "admin_user_password", with: "1234567"

      page.should have_selector "#admin_user_email"
      page.should have_selector "#admin_user_password"
    end
    click_button "Sign in"

    page.should have_content "Estoque"

    current_path.should == admin_dashboard_path
  end
end
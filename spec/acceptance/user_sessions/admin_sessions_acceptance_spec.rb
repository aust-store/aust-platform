require 'spec_helper'

feature "Admin User sessions" do
  before do
    @admin_user = Factory(:admin_user)
  end

  scenario "As a user, I'd like to sign in into my store admin" do
    visit new_admin_user_session_url

    fill_in "Email", with: @admin_user.email
    fill_in "Password", with: "123456"

    click_button "Sign in"
    current_path.should == admin_dashboard_path
  end
end
# encoding: utf-8
require 'acceptance_spec_helper'

feature "Super admin session" do
  background do
    @user = FactoryGirl.create(:super_admin_user)
  end

  scenario "As a super admin, I'm able to sign in" do
    visit super_admin_root_path
    current_path.should == new_super_admin_user_session_path

    fill_in "super_admin_user_email",    with: @user.email
    fill_in "super_admin_user_password", with: "123456"

    click_button "Sign in"
    current_path.should == super_admin_root_path
  end
end

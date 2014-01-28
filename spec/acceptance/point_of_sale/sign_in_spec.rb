require 'acceptance_spec_helper'

feature "Point of sale's users" do
  background do
    @admin_user = FactoryGirl.create(:admin_user, role: "point_of_sale")
    @company = @admin_user.company
    stub_subdomain(@company)
    visit new_admin_user_session_path

    within("form#new_admin_user") do
      fill_in "admin_user_email", with: @admin_user.email
      fill_in "admin_user_password", with: "1234567"
    end

    click_button "sign_in"
  end

  context "As a point of sale user" do
    scenario "I am redirected to the POS upon sign in" do
      current_path.should == admin_offline_root_path
    end
  end
end

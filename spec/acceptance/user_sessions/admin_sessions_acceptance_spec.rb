require 'acceptance_spec_helper'

feature "Admin User sessions", js: true do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
  end
  context "Successfully signed in" do
    scenario "As a user, I'd like to sign in into my store admin" do
      visit "/admin_users/sign_in"

      within("form#new_admin_user") do
        fill_in "admin_user_email", with: @admin_user.email
        fill_in "admin_user_password", with: "1234567"

        page.should have_selector "#admin_user_email"
        page.should have_selector "#admin_user_password"
      end
      click_button "sign_in"

      page.should have_content "Estoque"

      current_path.should == admin_dashboard_path
    end
  end

  context "Failure in sign in" do
    scenario "Redirects the user to sign in page when login into admin fails" do
      @admin_user = FactoryGirl.create( :admin_user,
                                        name: "wrongname",
                                        email: "email@email.com",
                                        password: 1234567890,
                                        password_confirmation: 1234567890,
                                        role: "founder"
                                      )
      login_into_admin
      current_path.should_not == admin_store_dashboard_path(@company)
      current_path.should == "/admin_users/sign_in"
    end
  end
end

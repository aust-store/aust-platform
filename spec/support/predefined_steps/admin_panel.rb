module AcceptanceSteps
  def login_into_admin
    @admin_user ||= Factory(:admin_user)
    visit "/admin_users/sign_in"

    within("form#new_admin_user") do
      fill_in "admin_user_email", with: @admin_user.email
      fill_in "admin_user_password", with: "1234567"

      page.should have_selector "#admin_user_email"
      page.should have_selector "#admin_user_password"
    end
    click_button "Sign in"
    save_and_open_page
  end
end

module AcceptanceSteps
  def login_into_admin
    @admin_user ||= FactoryGirl.create(:admin_user)
    @company = @admin_user.company
    stub_subdomain(@company)
    visit "/admin_users/sign_in"

    within("form#new_admin_user") do
      fill_in "admin_user_email", with: @admin_user.email
      fill_in "admin_user_password", with: "1234567"

      page.should have_selector "#admin_user_email"
      page.should have_selector "#admin_user_password"
    end
    click_button "sign_in"
  end
end

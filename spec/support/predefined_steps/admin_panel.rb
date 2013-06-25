module AcceptanceSteps
  def login_into_admin
    @admin_user ||= FactoryGirl.create(:admin_user)
    @company = @admin_user.company
    stub_subdomain(@company)
    visit "/admin/sign_in"

    within("form#new_admin_user") do
      fill_in "admin_user_email", with: @admin_user.email
      fill_in "admin_user_password", with: "1234567"

      page.should have_selector "#admin_user_email"
      page.should have_selector "#admin_user_password"
    end
    click_button "sign_in"
  end

  def login_into_super_admin
    @super_admin ||= FactoryGirl.create(:super_admin_user)
    visit new_super_admin_user_session_path

    within("form#new_super_admin_user") do
      fill_in "super_admin_user_email",    with: @super_admin.email
      fill_in "super_admin_user_password", with: "123456"
    end
    click_button "Sign in"
    puts "Sign in is broken." unless current_path == super_admin_root_path
  end
end

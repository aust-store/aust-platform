def login_into_admin
  admin_user = Factory(:admin_user)
  visit new_admin_user_session_url

  fill_in "Email", with: admin_user.email
  fill_in "Password", with: "123456"

  click_button "Sign in"
end
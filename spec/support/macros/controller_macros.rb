module ControllerMacros
  def login_admin(admin_user = nil)
    before do
      @admin_user = Factory(:admin_user)
      @request.env["devise.mapping"] = Devise.mappings[:admin_users]
      sign_in @admin_user
    end
  end
end

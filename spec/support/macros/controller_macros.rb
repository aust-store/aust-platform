module ControllerMacros
  def login_admin
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin_users]
      sign_in Factory.create(:admin_user)
    end
  end
end
module ControllerMacros
  def login_admin(admin_user = nil)
    before do
      @admin_user = FactoryGirl.create(:admin_user)
      @company = @admin_user.company
      @request.env["devise.mapping"] = Devise.mappings[:admin_users]
      sign_in @admin_user
    end
  end

  def login_user(user = true)
    before do
      if user.nil?
        request.env['warden'].stub(:authenticate!).
          and_throw(:warden, {:scope => :user})
        controller.stub :current_user => nil
      else
        request.env['warden'].stub :authenticate! => user
        controller.stub :current_user => user
      end
    end
  end
end

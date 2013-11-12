module ControllerMacros
  def login_admin(admin_user = nil)
    before do
      @admin_user = FactoryGirl.create(:admin_user)
      @company = @admin_user.company
      controller.stub(:current_company_by_subdomain) { @company }
      @request.env["devise.mapping"] = Devise.mappings[:admin_users]
      sign_in @admin_user
    end
  end

  def login_user(customer = true)
    before do
      if customer.nil?
        request.env['warden'].stub(:authenticate!).
          and_throw(:warden, {:scope => :customer})
        controller.stub :current_customer => nil
      else
        request.env['warden'].stub :authenticate! => customer
        controller.stub current_customer: customer
      end
    end
  end
end

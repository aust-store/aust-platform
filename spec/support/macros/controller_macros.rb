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

  def login_user(person = true)
    before do
      if person.nil?
        request.env['warden'].stub(:authenticate!).
          and_throw(:warden, {:scope => :person})
        controller.stub :current_customer => nil
      else
        request.env['warden'].stub :authenticate! => person
        controller.stub current_customer: person
      end
    end
  end
end

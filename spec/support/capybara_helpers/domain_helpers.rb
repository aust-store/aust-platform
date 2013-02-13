module CapybaraHelpers
  module DomainHelpers
    def stub_subdomain(subdomain = "mystore", domain = "example.com")
      subdomain = subdomain.handle unless subdomain.is_a?(String)
      ApplicationController.any_instance.stub(:current_subdomain) { subdomain }
      ApplicationController.any_instance.stub(:current_domain) { domain }
      Admin::Devise::SessionsController.any_instance.stub(:current_subdomain) { subdomain }
    end
  end
end

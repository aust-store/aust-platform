module CapybaraHelpers
  module DomainHelpers
    def stub_subdomain(subdomain = "mystore")
      subdomain = subdomain.handle unless subdomain.is_a?(String)
      ApplicationController.any_instance.stub(:current_subdomain) { subdomain }
      Admin::Devise::SessionsController.any_instance.stub(:current_subdomain) { subdomain }
    end
  end
end

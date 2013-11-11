module CapybaraHelpers
  module DomainHelpers
    def stub_subdomain(subdomain = "mystore", domain = "lvh.me")
      subdomain = subdomain.handle unless subdomain.is_a?(String)
      switch_to_subdomain(subdomain)
    end

    def switch_to_subdomain(subdomain)
      # lvh.me always resolves to 127.0.0.1
      hostname = subdomain ? "#{subdomain}.lvh.me" : "lvh.me"
      Capybara.app_host = "http://#{hostname}"
      Capybara.default_host = "http://#{hostname}"
    end

    def switch_to_main_domain
      switch_to_subdomain nil
    end
  end
end

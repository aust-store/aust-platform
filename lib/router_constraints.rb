require "active_support/core_ext/object"

module RouterConstraints
  class Store
    def matches?(request)
      request = RailsRequest.new(request)

      company = Company.where("handle = ? OR domain = ?",
                              request.current_subdomain,
                              request.current_domain).first

      company.present?
    end
  end

  class Marketing
    def matches?(request)
      !RouterConstraints::Store.new.matches?(request)
    end
  end

  class Iphone
    def matches?(request)
      user_agent = request.env["HTTP_USER_AGENT"]
      user_agent.try(:match, /iphone[ OS]{0,}[.]{0,1}[6-999]/i)
    end
  end

  class Default
    def matches?(request)
      !Iphone.new.matches?(request)
    end
  end
end

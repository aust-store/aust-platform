module ControllersExtensions
  module LoadingStore
    def self.included(base)
      base.before_filter :load_store_information
    end

    def current_store
      @company ||= load_store_information
    end

    def current_domain
      rails_request.current_domain
    end

    def current_subdomain
      rails_request.current_subdomain
    end

    private

    def rails_request
      ::RailsRequest.new(request)
    end

    def load_store_information
      Rails.logger.info "Visiting with subdomain: #{current_subdomain} - domain: #{current_domain}"
      @company ||= ::Store::CompanyDecorator.decorate(
        Company.where("handle = ? OR domain = ?",
                      current_subdomain,
                      current_domain).first
      )
    end
  end
end

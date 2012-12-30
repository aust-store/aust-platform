module ControllersExtensions
  module LoadingCompanyAccordingToDomain
    def self.included(base)
      base.before_filter :load_store_information
    end

    private

    def current_subdomain
      Rails.logger.info "Current request.subdomains: #{request.subdomains.inspect}"
      if request.subdomains.present?
        request.subdomains.first
      end
    end


    def load_store_information
      if current_subdomain.present?
        Rails.logger.info "Visiting store with '#{current_subdomain}' handle"
        @company ||= Company.find_by_handle(current_subdomain)
      end
    end
  end
end

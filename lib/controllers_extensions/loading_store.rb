module ControllersExtensions
  module LoadingStore
    def self.included(base)
      base.before_filter :load_store_information
    end

    def current_store
      @company ||= load_store_information
    end

    private

    def current_subdomain
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

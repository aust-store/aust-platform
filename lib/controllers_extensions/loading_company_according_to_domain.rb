module ControllersExtensions
  module LoadingCompanyAccordingToDomain
    def self.included(base)
      base.before_filter :load_store_information
    end

    private

    def current_subdomain
      if request.subdomain.present?
        Array(request.subdomain).last
      end
    end


    def load_store_information
      if current_subdomain.present?
        Rails.logger.info "Visiting #{current_subdomain} store."
        @company ||= Company.find_by_handle(current_subdomain)
      end
    end
  end
end

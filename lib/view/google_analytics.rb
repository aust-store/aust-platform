module View
  class GoogleAnalytics
    def initialize(controller, company)
      @controller = controller
      @company = company
    end

    def enabled?
      self.tracking_id.present?
    end

    def tracking_id
      company.google_analytics_id
    end

    def domain
      if company.domain.present?
        company.domain
      else
        rails_request.current_domain
      end
    end

    private

    attr_reader :company, :controller

    def rails_request
      ::RailsRequest.new(controller.request)
    end
  end
end

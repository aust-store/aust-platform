module Controllers
  class Url
    def initialize(controller)
      @controller = controller
    end

    def current_if_same_url(url_name)
      if controller.url_for == url_name ||
        matches_route?(url_name) ||
        controller_name == url_name.to_s
        "current"
      end
    end

    private

    attr_reader :controller

    def controller_name
      controller.params[:controller]
    end

    def matches_route?(route_name)
      return unless controller.respond_to?(route_name.to_sym)
      controller.url_for == controller.send(route_name.to_sym)
    end
  end
end

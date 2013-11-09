module View
  class LayoutConstraints
    def initialize(controller)
      @controller = controller
    end

    def show_vertical_taxonomy_menu?
      [ "store/product",
        "store/categories",
        "store/home" ].include?(controller_name)
    end

    private

    attr_reader :controller

    def controller_name
      controller.params[:controller]
    end
  end
end

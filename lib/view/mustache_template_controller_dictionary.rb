module View
  class MustacheTemplateControllerDictionary
    def initialize(controller)
      @controller = controller
    end

    def template_for_controller
      dictionary[controller_action_name]
    end

    private

    attr_reader :controller

    def params
      controller.params
    end

    def controller_action_name
      params[:controller].gsub(/\//, "_") + "/" + params[:action]
    end

    # This is the dictionary of Mustache templates to open depending on the
    # controller.
    def dictionary
      { "store_home/index"    => "home",
        "store_products/show" => "product" }
    end
  end
end

module View
  # FIXME - find a better name
  #
  # This relates strictly to Mustache templates
  class MustacheContentForLayout
    include ActionView::Context
    include ActionView::Helpers::OutputSafetyHelper
    include ActionView::Helpers::CaptureHelper

    def initialize(view)
      @view = view
      @file_content = {}
    end

    def content_for(element = :layout)
      template = mustache_template(element)
      if template
        View::StoreTheme::MustacheTemplate.new(view).render(template)
      else
        nil
      end
    end

    private

    attr_reader :view

    def mustache_template(element)
      if File.exists?(mustache_template_path(element))
        @file_content[element.to_sym] ||= File.read(mustache_template_path(element))
      end
    end

    def mustache_template_path(element)
      path =  []
      path << view.theme_path
      path << view.theme_name
      path << mustache_template_name(element)
      path.join("/")
    end

    def mustache_template_name(element)
      if element == :layout
        "#{mustache_template_for_layout}.mustache"
      else
        "#{element.to_s}.mustache"
      end
    end

    def mustache_template_for_layout
      dictionary = MustacheTemplateControllerDictionary.new(view.controller)
      dictionary.template_for_controller
    end
  end
end

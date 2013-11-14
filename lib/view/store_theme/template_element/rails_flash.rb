module View
  module StoreTheme
    module TemplateElement

      # All data related to Rails' flash messages.
      #
      # This module will be used in a mustache template. Consider that we have
      # the following hypothetical placeholder in a view (e.g `layout.mustache`):
      #
      #   Welcome to {{{company_name}}}
      #
      # Mustache will call the method `company_name`, which is defined in
      # TemplateElement::Company, thus replacing the placeholder with the
      # actual value.
      #
      module RailsFlash
        def notices
          result = ""
          result << content_tag(:div, controller.flash[:notice], id: "flash_notice") if controller.flash[:notice]
          result << content_tag(:div, controller.flash[:alert], id: "flash_alert") if controller.flash[:alert]
          result << content_tag(:div, nil, id: "error", data: {observe: "error"})
          raw result
        end
      end
    end
  end
end

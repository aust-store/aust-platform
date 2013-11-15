module View
  module StoreTheme
    module TemplateElement

      # All data related to the pages is grouped here.
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
      module Pages
        def pages
          view.pages.map do |page|
            { page_name: raw(page.title),
              page_path: raw(controller.page_path(page)) }
          end
        end
      end
    end
  end
end

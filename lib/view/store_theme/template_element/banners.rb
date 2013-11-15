module View
  module StoreTheme
    module TemplateElement

      # All data related to banners.
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
      module Banners
        def main_rotative_banners
          result = ""
          if banners?(:main_page_central_rotative)
            result << content_tag(:div, class: "main_page_central_transitional_banners") do
              banners(:main_page_central_rotative)
            end

            if banners_amount(:main_page_central_rotative) > 1
              result << content_tag(:div, class: "main_page_central_transitional_banners_navigation")
            end
          end
          raw(result)
        end

        def all_pages_right_banners
          raw banners(:all_pages_right, width: 200)
        end
      end
    end
  end
end

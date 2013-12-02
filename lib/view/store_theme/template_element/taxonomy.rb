module View
  module StoreTheme
    module TemplateElement

      # All data related to taxonomy.
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
      module Taxonomy
        extend TemplateElementsDocumentation

        desc "taxonomy"
        def taxonomy
          raw taxonomies_navigation(view.taxonomy)
        end
      end
    end
  end
end

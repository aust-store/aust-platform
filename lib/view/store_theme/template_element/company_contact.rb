module View
  module StoreTheme
    module TemplateElement

      # All data regarding the current store's contact information is grouped here.
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
      module CompanyContact
        extend TemplateElementsDocumentation

        desc "contact_enabled?"
        def contact_enabled?
          view.company.contact_email.present?
        end
      end
    end
  end
end

module View
  module StoreTheme
    module TemplateElement

      # All data related to the customer is grouped here.
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
      module Customer
        extend TemplateElementsDocumentation

        desc "customer_status"
        def customer_status
          result = ""
          if controller.person_signed_in?
            result << "Olá, #{controller.current_customer.first_name}. "
            result << link_to("Sair",
                              controller.destroy_person_session_path,
                              method: :delete)
          else
            result << "Olá. Já é cadastrado? "
            result << raw(link_to("Login", controller.new_person_session_path))
          end

          raw result
        end
      end
    end
  end
end

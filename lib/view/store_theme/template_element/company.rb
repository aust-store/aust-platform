module View
  module StoreTheme
    module TemplateElement

      # All data regarding the current store is groups here.
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
      module Company
        def company_name
          view.company.name
        end


        def company
          company = view.company
          address = company.address || company.build_address

          { name: company.name,
            address: {
              address_1:    address.address_1,
              address_2:    address.address_2,
              neighborhood: address.neighborhood,
              city:         address.city,
              state:        address.state,
              zipcode:      address.zipcode
            },
            contact: {
              phone_1: company.contact.phone_1,
              phone_2: company.contact.phone_2,
              email:   company.contact.email
            }
          }
        end
      end
    end
  end
end

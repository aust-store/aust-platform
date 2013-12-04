module View
  module StoreTheme
    module TemplateElement

      # All data regarding the current store is grouped here.
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
        extend TemplateElementsDocumentation

        desc "company_name"
        def company_name
          view.company.name
        end

        desc "company", block: true
        def company
          company = view.company
          address = company.address || company.build_address
          contact = company.contact || company.build_contact

          i18n_block = "mustache_commands.company.block"
          {
            I18n.t("#{i18n_block}.name") => company.name,
            I18n.t("#{i18n_block}.address") => {
              I18n.t("#{i18n_block}.address_1")    => address.address_1,
              I18n.t("#{i18n_block}.address_2")    => address.address_2,
              I18n.t("#{i18n_block}.neighborhood") => address.neighborhood,
              I18n.t("#{i18n_block}.city")         => address.city,
              I18n.t("#{i18n_block}.state")        => address.state,
              I18n.t("#{i18n_block}.zipcode")      => address.zipcode
            },
            I18n.t("#{i18n_block}.contact") => {
              I18n.t("#{i18n_block}.phone_1") => contact.phone_1,
              I18n.t("#{i18n_block}.phone_2") => contact.phone_2,
              I18n.t("#{i18n_block}.email")   => contact.email
            }
          }
        end
      end
    end
  end
end

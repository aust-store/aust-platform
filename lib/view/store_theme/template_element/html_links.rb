module View
  module StoreTheme
    module TemplateElement

      # All data related to creating links around the store.
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
      module HtmlLinks
        extend TemplateElementsDocumentation

        desc "root_path"
        def root_path
          controller.root_path
        end

        desc "contact_path"
        def contact_path
          controller.new_contact_path
        end

        desc "current_root_path"
        def current_root_path
          current_path_class(:root_url)
        end

        desc "current_contact_path"
        def current_contact_path
          current_path_class(:new_contact_url)
        end

        private

        def current_path_class(path_id)
          Controllers::Url.new(controller).current_if_same_url(path_id)
        end
      end
    end
  end
end

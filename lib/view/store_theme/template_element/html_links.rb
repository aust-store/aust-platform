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
        def root_path
          controller.root_path
        end

        def contact_path
          controller.new_contact_path
        end

        def method_missing(method, *args, &block)
          # Check if method name is something like the following:
          #
          #   current_root_path
          #
          # If yes, returns `current` string. This allows users to use this in
          # themes:
          #
          #   <a href="{{{root_path}}}" class="{{current_root_path}}}">Main</a>
          #
          if method.to_s =~ /\Acurrent_(.*_path)\Z/
            route_name = $1.gsub(/_path\Z/, "_url")
            current_path_class(route_name)
          else
            super
          end
        end

        private

        def current_path_class(path_id)
          if controller.url_for == controller.send(path_id.to_sym) ||
            controller_name == path_id
            "current"
          end
        end
      end
    end
  end
end

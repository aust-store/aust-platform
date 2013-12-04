module View
  module StoreTheme
    module TemplateElement

      # All data related to the store's cart is grouped here.
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
      module Cart
        extend TemplateElementsDocumentation

        desc :cart_status
        def cart_status
          return unless view.company.sales_enabled?
          result = if controller.cart_items_quantity == 1
            link_to("Você possui 1 item no carrinho.", controller.cart_path, id: "path_to_cart")
          elsif controller.cart_items_quantity > 1
            link_to("Você possui #{controller.cart_items_quantity} itens no carrinho.",
                    controller.cart_path, id: "path_to_cart")
          else
            "Seu carrinho está vazio."
          end
          raw result
        end

      end
    end
  end
end

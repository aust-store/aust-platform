module View
  module StoreTheme
    module TemplateElement

      # All data related to products.
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
      module Products
        extend TemplateElementsDocumentation

        # Block for listing products.
        #
        # `view.products` should return the current page's product listing. On
        # the front page, that should probably mean the front page products.
        #
        # If you're in a category, that means the products in that category.
        # It's the controller the responsible for different products.
        #
        desc "products", block: true
        def products
          view.products.each_with_index.map do |product, index|
            product_attributes(product).merge({ index: index })
          end
        end

        desc "product", block: true
        def product
          product_attributes(view.product)
        end

        private

        def add_to_cart_link(product)
          if view.company.sales_enabled?
            raw link_to(
              "Comprar",
              cart_items_path(id: product),
              method: :post,
              class: "btn positive_action_btn",
              id: "add_to_cart"
            )
          end
        end

        def product_attributes(product)
          { i18n_block(:id)              => product.id,
            i18n_block(:name)            => product.name,
            i18n_block(:description)     => product.description,
            i18n_block(:merchandising)   => product.merchandising,
            i18n_block(:price)           => product.price,
            i18n_block(:price?)          => product.price.present?,
            i18n_block(:product_href)    => controller.product_path(product),
            i18n_block(:add_to_cart_btn) => add_to_cart_link(product),
            i18n_block(:cover_image)     => cover_image(product),
            i18n_block(:images)          => images(product) }
        end

        def cover_image(product)
          cover_image = product.images.cover.first
          { i18n_block(:small_size_src)    => cover_image.image.url(:cover_standard),
            i18n_block(:medium_size_src)   => cover_image.image.url(:cover_big),
            i18n_block(:original_size_src) => cover_image.image.url(:natural)
          }
        end

        def images(product)
          product.images.non_cover.map do |image|
            { i18n_block(:thumb_size_src)   => image.image.url(:thumb),
              i18n_block(:original_size_src) => image.image.url(:natural) }
          end
        end

        def i18n_block(key_to_be_translated)
          i18n_block = "mustache_commands.products.block"
          I18n.t("#{i18n_block}.#{key_to_be_translated}")
        end
      end
    end
  end
end

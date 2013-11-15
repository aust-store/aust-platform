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
        # Block for listing products.
        #
        # `view.products` should return the current page's product listing. On
        # the front page, that should probably mean the front page products.
        #
        # If you're in a category, that means the products in that category.
        # It's the controller the responsible for different products.
        #
        def products
          view.products.each_with_index.map do |product, index|
            small_cover_image = product.images.cover.first

            attributes = product_attributes(product)
            attributes.merge({
              index: index,
              cover_image: {
                id:  small_cover_image.id,
                src: small_cover_image.image.url(:cover_standard)
              }
            })
          end
        end

        def product
          resource = view.product
          big_cover_image = resource.images.first

          attributes = product_attributes(resource)
          attributes.merge({
            cover_image: {
              id:  big_cover_image.id,
              src: big_cover_image.image.url(:cover_big),
              big_image: big_cover_image.image.url(:natural)
            },
            images: resource.images.non_cover.map { |image|
              { src_thumb:   image.image.url(:thumb),
                src_natural: image.image.url(:natural) }
            },
            add_to_cart_btn: add_to_cart_link(resource)
          })
        end

        private

        def add_to_cart_link(product)
          raw link_to(
            "Comprar",
            cart_items_path(id: product),
            method: :post,
            class: "btn positive_action_btn",
            id: "add_to_cart"
          )
        end

        def product_attributes(product)
          { id:            product.id,
            name:          product.name,
            description:   product.description,
            merchandising: product.merchandising,
            price:         product.price,
            price?:        product.price.present?,
            product_path:  controller.product_path(product) }
        end
      end
    end
  end
end

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
          i18n_block = "mustache_commands.products.block"
          view.products.each_with_index.map do |product, index|
            small_cover_image = product.images.cover.first

            attributes = product_attributes(product)
            attributes.merge({
              index: index,
              I18n.t("#{i18n_block}.cover_image") => {
                I18n.t("#{i18n_block}.id") =>  small_cover_image.id,
                I18n.t("#{i18n_block}.src") => small_cover_image.image.url(:cover_standard),
                I18n.t("#{i18n_block}.big_image") => small_cover_image.image.url(:natural)
              }
            })
          end
        end

        desc "product", block: true
        def product
          resource = view.product
          big_cover_image = resource.images.first

          i18n_block = "mustache_commands.products.block"
          attributes = product_attributes(resource)
          attributes.merge({
            I18n.t("#{i18n_block}.cover_image") => {
              I18n.t("#{i18n_block}.id")  =>  big_cover_image.id,
              I18n.t("#{i18n_block}.src") => big_cover_image.image.url(:cover_big),
              I18n.t("#{i18n_block}.big_image") => big_cover_image.image.url(:natural)
            },
            I18n.t("#{i18n_block}.images") => resource.images.non_cover.map { |image|
              { I18n.t("#{i18n_block}.src_thumb") => image.image.url(:thumb),
                I18n.t("#{i18n_block}.src_natural") => image.image.url(:natural) }
            },
            I18n.t("#{i18n_block}.add_to_cart_btn") => add_to_cart_link(resource)
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
          i18n_block = "mustache_commands.products.block"
          { I18n.t("#{i18n_block}.id") => product.id,
            I18n.t("#{i18n_block}.name") => product.name,
            I18n.t("#{i18n_block}.description") => product.description,
            I18n.t("#{i18n_block}.merchandising") => product.merchandising,
            I18n.t("#{i18n_block}.price") => product.price,
            I18n.t("#{i18n_block}.price?") => product.price.present?,
            I18n.t("#{i18n_block}.product_href") => controller.product_path(product) }
        end
      end
    end
  end
end

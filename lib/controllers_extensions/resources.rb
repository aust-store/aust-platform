module ControllersExtensions
  module Resources
    def self.included(base)
      # TODO - this can be removed when we move all themes to Mustache. Then,
      # we'll make calls to these method right from the template, allowing us
      # to lazily evaluate them.
      #
      # Before mustache, we need to preload these to be used in ERB.
      base.before_filter :taxonomies
      base.before_filter :pages
      base.before_filter :cart_items_quantity
      base.before_filter :banners
    end

    def pages
      @pages ||= current_store.pages.to_a
    end

    def taxonomies
      @taxonomies ||= current_store.taxonomies_as_hash
    end

    def products
      items = ::Store::ItemsForSale.new(self).items_for_main_page
      @items = ::Store::InventoryItemDecorator.decorate_collection(items)
      @products ||= @items
    end

    def cart_items_quantity
      @cart_items_quantity = cart.total_unique_items
    end

    def banners
      @banners ||= {
        all_pages_right: current_store.banners.all_pages_right
      }
    end
  end
end

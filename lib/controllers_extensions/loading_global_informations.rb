module ControllersExtensions
  module LoadingGlobalInformations
    def self.included(base)
      base.before_filter :load_taxonomies
      base.before_filter :load_pages
      base.before_filter :cart_items_quantity
      base.before_filter :load_application_wide_ad_banners
    end

    def load_pages
      @pages = current_store.pages.to_a
    end

    def load_taxonomies
      @taxonomies = current_store.taxonomies.hash_tree_for_homepage
    end

    def cart_items_quantity
      @cart_items_quantity = cart.total_unique_items
    end

    def load_application_wide_ad_banners
      @banners = {
        all_pages_right: current_store.banners.all_pages_right
      }
    end
  end
end

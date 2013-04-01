module ControllersExtensions
  module LoadingGlobalInformations
    def self.included(base)
      base.before_filter :load_taxonomies
      base.before_filter :cart_items_quantity
    end

    def load_taxonomies
      @taxonomies = current_store.taxonomies.hash_tree_for_homepage
    end

    def cart_items_quantity
      @cart_items_quantity = cart.total_unique_items
    end
  end
end

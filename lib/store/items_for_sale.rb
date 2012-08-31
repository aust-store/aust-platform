module Store
  class ItemsForSale
    def initialize(controller)
      @controller = controller
    end

    def items_for_homepage
      entries = current_store.distinct_inventory_entries
    end

    def item_for_cart
      current_store.inventory_entries.find(entry_id)
    end

    def inventory_entry
      current_store.inventory_entries.find(entry_id)
    end

  private

    def current_store
      @controller.current_store
    end

    def entry_id
      @controller.params[:id]
    end
  end
end

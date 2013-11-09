module Store
  class ItemsForSale
    def initialize(controller)
      @controller = controller
    end

    def items_for_main_page
      current_store.items_on_sale_on_main_page
    end

    def items_for_category
      current_store.items_on_sale_in_category(entry_id)
    end

    def item_for_cart
      inventory_entry
    end

    def inventory_entry
      current_store.inventory_entries.find(entry_id)
    end

    def detailed_item_for_show_page
      current_store.detailed_item(item_id)
    end

  private

    def current_store
      @controller.current_store
    end

    def entry_id
      @controller.params[:id]
    end

    def item_id
      inventory_entry.inventory_item.id
    end
  end
end

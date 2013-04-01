module Persistence
  class OrderItemQuantity
    def initialize(order_item)
      @item = order_item
    end

    # FIXME improve tests
    def change(new_quantity)
      new_quantity = sanitize_quantity(new_quantity)

      if new_quantity > item.quantity
        create_children(new_quantity)
      else
        destroy_exceeding_children(new_quantity)
      end
    end

    private

    attr_accessor :item

    def create_children(new_quantity)
      # FIXME add an ActiveRecord transaction
      (new_quantity - item.quantity).times do
        item.children << item.children.create(item.inherited_attributes)
      end
    end

    def destroy_exceeding_children(new_quantity)
      item.quantity = 0 if new_quantity <= 0
      item.children.limit(item.quantity - new_quantity).destroy_all
    end

    def sanitize_quantity(new_quantity)
      new_quantity = 0 if new_quantity < 0
      new_quantity = remaining_entries_in_stock if new_quantity > remaining_entries_in_stock

      new_quantity.to_i
    end

    def remaining_entries_in_stock
      item.inventory_entry.quantity
    end
  end
end

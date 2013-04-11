module Store
  module Stock
    class DecrementAfterOrder
      def initialize(order)
        @order = order
      end

      def subtract
        entries_to_subtract.each do |entry_id, quantity_to_subtract|
          entry = InventoryEntry.find(entry_id)
          entry.update_attributes(quantity: (entry.quantity - quantity_to_subtract))
        end
      end

      private

      attr_reader :order

      # Private: returns a hash the summary of what and how much should be
      # subtracted.
      #
      # Returns a hash with entry id as key and the amount to subtract as value
      #
      #   Example:
      #
      #     { 1 => 3,
      #       2 => 2 }
      #
      #     - entry with id 1 should have 3 items withdrawn
      #     - entry with id 2 should have 2 items withdrawn
      def entries_to_subtract
        inventory_entries = {}
        order_items.each do |item|
          # current amount to subtract
          current_value = inventory_entries[item.inventory_entry_id] || 0
          inventory_entries[item.inventory_entry_id] = current_value + 1
        end
        inventory_entries
      end

      def order_items
        @order_items ||= order.items
      end
    end
  end
end

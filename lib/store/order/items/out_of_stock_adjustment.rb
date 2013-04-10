module Store
  module Order
    module Items
      class OutOfStockAdjustment
        def initialize(cart)
          @cart = cart
        end

        def adjust
          order_items.each do |item|
            entry_quantity = item.inventory_entry.quantity
            item.update_quantity(entry_quantity) if item.quantity > entry_quantity
          end
        end

        private

        attr_accessor :cart

        def order_items
          cart.items.parent_items
        end
      end
    end
  end
end


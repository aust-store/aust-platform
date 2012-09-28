module Store
  class Cart
    class ItemsList
      def initialize(cart)
        @cart = cart
        @items = []
      end

      def list
        @cart.all_items.each { |e| add_item_to_cart_list(e) }
        @items
      end

    private

      def add_item_to_cart_list(persisted_item)
        existing_item = @items.find do |cart_item|
          cart_item.id == persisted_item.inventory_entry_id &&
            cart_item.price == persisted_item.price
        end

        if existing_item
          existing_item.quantity += 1
        else
          @items << Store::Cart::Item.new(persisted_item)
        end
      end
    end
  end
end

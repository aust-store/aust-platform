module Store
  class Cart
    class ItemsList
      def initialize(cart)
        @cart = cart
        @items = []
      end

      def list
        @cart.all_items.each do |e|
          @items << Store::Cart::Item.new(e)
        end
        @items
      end
    end
  end
end

module Store
  class Cart
    class Item
      def initialize(persisted_item)
        @persisted_item = persisted_item
        @quantity = 1
      end

      def id
        @persisted_item.id
      end

      def quantity
        @persisted_item.quantity.to_i
      end

      def name
        @persisted_item.name
      end

      def description
        @persisted_item.description 
      end

      def price
        @persisted_item.price 
      end
    end
  end
end

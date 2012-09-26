module Store
  class Cart
    class Item
      attr_accessor :quantity

      def initialize(persisted_item)
        @persisted_item = persisted_item
        @quantity = 1
      end

      def id
        @persisted_item.inventory_entry_id
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

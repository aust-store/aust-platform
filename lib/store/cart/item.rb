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

      def entry_id
        @persisted_item.inventory_entry_id
      end

      def price
        ::Money.new(@persisted_item.price).humanize
      end
    end
  end
end

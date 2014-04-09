module Store
  module InventoryItem
    class Deletable
      def initialize(item_model) # InventoryItem
        @item_model = item_model
      end

      def valid?
        !associated_with_order?
      end

      private

      attr_reader :item_model

      def associated_with_order?
        @item_model.order_items.present?
      end
    end
  end
end

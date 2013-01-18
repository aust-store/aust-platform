module Store
  module Policy
    class ItemOnSale
      attr_reader :item

      def initialize(inventory_item)
        @item = inventory_item
      end

      def on_sale?
        has_price?           and
          has_entry_on_sale? and
          has_cover_image?   and
          has_shipping_box?
      end

      private

      def has_price?
        !!Store::ItemPrice.new(item).price
      end

      def has_entry_on_sale?
        !!item.entry_for_sale
      end

      def has_cover_image?
        item.images.has_cover?
      end

      def has_shipping_box?
        item.shipping_box.present?
      end
    end
  end
end

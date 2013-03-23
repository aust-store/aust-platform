module Store
  module OnlineSales
    class ItemRequirementsForSale
      attr_reader :item

      def initialize(inventory_item)
        @item = inventory_item
      end

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

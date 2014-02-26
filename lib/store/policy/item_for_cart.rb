module Store
  module Policy
    class ItemForCart
      def initialize(inventory_item)
        @item = inventory_item
      end

      def valid?
        errors.blank?
      end

      private

      attr_reader :item

      def errors
        messages = []
        messages << :sales_disabled unless item.company.sales_enabled?
        messages << :invalid_shipping_box unless valid_shipping_box?
        messages
      end

      def valid_shipping_box?
        item.shipping_box and item.shipping_box.valid?
      end
    end
  end
end

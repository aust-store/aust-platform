module Store
  module Policy
    class ItemOnSale
      attr_reader :item

      def initialize(inventory_item)
        @item = inventory_item
      end

      def on_sale?
        OnlineSales::ReasonForItemNotOnSale.new(item).reasons.blank?
      end
    end
  end
end

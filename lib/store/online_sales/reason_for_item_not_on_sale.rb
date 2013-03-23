module Store
  module OnlineSales
    class ReasonForItemNotOnSale
      attr_reader :item

      def initialize(inventory_item)
        @item = inventory_item
      end

      def reasons
        messages = []
        messages << :has_no_price         unless requirements.has_price?
        messages << :has_no_entry_on_sale unless requirements.has_entry_on_sale?
        messages << :has_no_cover_image   unless requirements.has_cover_image?
        messages << :has_no_shipping_box  unless requirements.has_shipping_box?
        messages
      end

      private

      def requirements
        @requirements ||= Store::OnlineSales::ItemRequirementsForSale.new(item)
      end
    end
  end
end

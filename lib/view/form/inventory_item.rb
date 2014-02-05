module View
  module Form
    class InventoryItem
      def initialize(controller)
        @controller = controller
      end

      def form_object(model)
        build_associations(model)
        DecorationBuilder.inventory_items(model)
      end

      private

      attr_reader :controller

      def current_company
        controller.current_company
      end

      # builds the resource
      def build_associations(model)

        # when creating the object
        if model.new_record?
          model.entries.build if model.entries.blank?
          model.images.build  if model.images.blank?
        end

        model.prices.build       if model.prices.blank?
        model.build_manufacturer if model.manufacturer.blank?
        model.build_taxonomy     if model.taxonomy.blank?
        model.build_shipping_box if model.shipping_box.blank?
      end
    end
  end
end

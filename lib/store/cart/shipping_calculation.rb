module Store
  class Cart
    class ShippingCalculation
      def initialize(controller, country = "BR")
        @controller = controller
        @country = country
      end

      def self.create(controller, country = "BR")
        new(controller, country).create
      end

      def create
        options = {
          source_zipcode:      source_zipcode,
          destination_zipcode: destination_zipcode,
          items:               items,
          shipping_type:       type,
          country:             @country
        }
        calculation = ::Store::Logistics::Shipping::Calculation.new(options)
        result = calculation.calculate

        if result.success?
          OrderShipping.create_for_cart(
            price:          result.total,
            delivery_days:  result.days,
            delivery_type:  :correios,
            service_type:   type,
            zipcode:        destination_zipcode,
            cart:           cart,
            package_width:  result.width,
            package_length: result.length,
            package_height: result.height,
            package_weight: result.weight
          )
        end

        result
      end

      private

      def cart
        @controller.cart.persisted_cart
      end

      def items
        @controller.cart_items_dimensions
      end

      def source_zipcode
        @controller.current_store.zipcode
      end

      def destination_zipcode
        @controller.params[:zipcode]
      end

      def type
        @controller.params[:type]
      end
    end
  end
end

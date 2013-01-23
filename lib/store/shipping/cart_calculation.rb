module Store
  module Shipping
    class CartCalculation
      def initialize(controller, country = :br)
        @controller = controller
        @country = country
      end

      def self.create(controller, country, params)
        new(controller, country).create
      end

      def create
        calculation = Store::Shipping::Calculation.new(@controller, @country)
        result = calculation.calculate(zipcode, type)

        OrderShipping.create_for_cart(
          price: result.total, delivery_days: result.days,
          delivery_type: :correios, service_type: type,
          zipcode: zipcode, cart: cart
        )
        result
      end

      private

      def cart
        @controller.cart.persisted_cart
      end

      def zipcode
        @controller.params[:zipcode]
      end

      def type
        @controller.params[:type]
      end
    end
  end
end
module Store
  module Shipping
    class CartCalculation
      def initialize(controller, country = :br)
        @controller = controller
        @country = country
      end

      def create(client_zipcode, type)
        calculation = Store::Shipping::Calculation.new(@controller, @country)
        result = calculation.calculate(client_zipcode, type)

        OrderShipping.create_for_cart(
          price: result.total, delivery_days: result.days,
          delivery_type: :correios, service_type: :pac,
          cart: cart
        )
        result
      end

      private

      def cart
        @controller.cart.persisted_cart
      end
    end
  end
end

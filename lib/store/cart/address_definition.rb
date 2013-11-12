module Store
  class Cart
    class AddressDefinition
      def initialize(controller, cart)
        @controller = controller
        @cart       = cart
      end

      def use_customers_default_address
        address = cart.shipping_address and address.destroy
        cart.build_shipping_address(current_customer.default_address.copied)
        cart.save
      end

      private

      attr_accessor :cart, :controller

      def current_customer
        controller.current_customer
      end
    end
  end
end

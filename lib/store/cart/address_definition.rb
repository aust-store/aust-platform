module Store
  class Cart
    class AddressDefinition
      def initialize(controller, cart)
        @controller = controller
        @cart       = cart
      end

      def use_users_default_address
        address = cart.shipping_address and address.destroy
        cart.build_shipping_address(current_user.default_address.copied)
        cart.save
      end

      private

      attr_accessor :cart, :controller

      def current_user
        controller.current_user
      end
    end
  end
end

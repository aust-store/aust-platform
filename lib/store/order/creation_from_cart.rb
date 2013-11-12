module Store
  module Order
    class CreationFromCart
      def initialize(cart)
        @cart = cart
      end

      def convert_cart_into_order
        order = ::Order.create(serialized_fields)
        cart.items.each { |item| order.items << item }
        order.save
        order
      end

      private

      attr_accessor :cart

      def serialized_fields
        { cart_id:          cart.id,
          environment:      cart.environment,
          customer:         cart.customer,
          store:            cart.company,
          shipping_address: cart.shipping_address,
          shipping_details: cart.shipping }
      end
    end
  end
end

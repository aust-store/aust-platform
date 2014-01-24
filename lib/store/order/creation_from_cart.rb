module Store
  module Order
    class CreationFromCart
      def initialize(cart, options = {})
        @cart = cart
        @options = options
      end

      def convert_cart_into_order
        order = ::Order.create(serialized_fields)
        cart.items.each { |item| order.items << item }
        order.save
        order
      end

      private

      attr_accessor :cart, :options

      def serialized_fields
        result = {
          cart_id:          cart.id,
          environment:      cart.environment,
          customer:         cart.customer,
          store:            cart.company,
          shipping_address: cart.shipping_address,
          shipping_details: cart.shipping
        }
        result[:uuid] = options[:order_uuid] if options[:order_uuid].present?
        result
      end
    end
  end
end

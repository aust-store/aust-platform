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
          shipping_details: cart.shipping,
          total:            order_total
        }

        [:payment_type, :uuid, :admin_user_id].each do |field|
          result[field] = options[field] if options[field].present?
        end
        result
      end

      def order_total
        calculation = Store::Order::PriceCalculation.new(nil, cart.items)
        calculation.total(options[:payment_type])
      end
    end
  end
end

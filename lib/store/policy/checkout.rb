module Store
  module Policy
    class Checkout
      def initialize(controller)
        @controller = controller
      end

      def enabled?
        payment_gateway and payment_gateway.active?
      end

      private

      def store
        @controller.current_store
      end

      def payment_gateway
        store.payment_gateway
      end
    end
  end
end

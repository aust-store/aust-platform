module Store
  module Checkout
    class ShippingController < Store::CheckoutBaseController
      def show
        # TODO test cart has user
        cart.set_user
        @cart = cart.persistence
      end

      def update
        cart.set_shipping_address
        redirect_to checkout_payment_url and return
      end
    end
  end
end

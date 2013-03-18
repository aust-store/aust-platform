module Store
  module Checkout
    class PaymentController < Store::CheckoutBaseController
      skip_before_filter :load_taxonomies

      def show
        order = cart.convert_into_order
        flush_cart
        pagseguro = Store::Payment::Pagseguro::Checkout.new(self, order)
        pagseguro.create_transaction
        redirect_to pagseguro.payment_url
      end

      def after_payment_return_url(gateway)
        { pagseguro: checkout_success_url }[gateway]
      end
    end
  end
end

module Store
  module Checkout
    class PaymentController < Store::CheckoutBaseController
      def show
        pagseguro = Store::Payment::Pagseguro::Checkout.new(self, cart)
        pagseguro.create_transaction
        cart.convert_into_order
        redirect_to pagseguro.payment_url and return
      end

      def after_payment_return_url(gateway)
        { pagseguro: checkout_success_url }[gateway]
      end
    end
  end
end

module Store
  module Checkout
    class PaymentController < Store::CheckoutBaseController
      def show
        cart.convert_into_order
        pagseguro = Store::Payment::Pagseguro::Checkout.new(self, cart)
        pagseguro.create_transaction
        redirect_to pagseguro.payment_url and return
      end

      def after_payment_return_url(gateway)
        { pagseguro: checkout_success_url }[gateway]
      end
    end
  end
end

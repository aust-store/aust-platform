module Store
  module Checkout
    class PaymentController < Store::CheckoutBaseController
      def show
        pagseguro = Store::Payment::Pagseguro::Checkout.new(self, cart)
        pagseguro.create_transaction
        redirect_to pagseguro.payment_url and return
      end

      def return_urls
        { pagseguro: gateway_notifications_pagseguro_url }
      end
    end
  end
end

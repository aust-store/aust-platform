module Store
  module Checkout
    class PaymentController < Store::CheckoutBaseController
      skip_before_filter :load_taxonomies

      def show
        sale = Store::Sale.new(cart.persistence)
        sale.close

        reset_cart
        pagseguro = Store::Payment::Pagseguro::Checkout.new(self, sale.order)
        pagseguro.create_transaction
        redirect_to pagseguro.payment_url
      end

      def after_payment_return_url(gateway)
        { pagseguro: checkout_success_url }[gateway]
      end
    end
  end
end

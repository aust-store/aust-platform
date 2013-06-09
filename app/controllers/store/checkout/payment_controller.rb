module Store
  module Checkout
    class PaymentController < Store::CheckoutBaseController
      skip_before_filter :load_taxonomies

      def show
        if cart.persistence.zipcode_mismatch?
          ::Store::CartShippingCalculation.create(self, shipping_options)
        end

        sale = Store::Sale.new(cart.persistence)
        sale.close

        reset_cart
        pagseguro = Store::Payment::Pagseguro::Checkout.new(self, sale.order)
        pagseguro.create_transaction

        redirect_to pagseguro.payment_url
      rescue InventoryEntry::NegativeQuantity => e
        Store::Order::Items::OutOfStockAdjustment.new(cart.persistence).adjust
        redirect_to cart_path, alert: t("store.errors.checkout.entry_with_negative_quantity")
      end

      def after_payment_return_url(gateway)
        { pagseguro: checkout_success_url }[gateway]
      end

      private

      def shipping_options
        { destination_zipcode: cart.persistence.shipping.zipcode,
          type:                cart.persistence.shipping.service_type }
      end
    end
  end
end

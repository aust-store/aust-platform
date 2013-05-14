module Store
  module Checkout
    class ShippingController < Store::CheckoutBaseController
      before_filter :define_cart_persistence

      def show
        # TODO test cart has user
        @cart.set_user(current_user)
        prepare_show_view
      end

      def update
        if use_custom_shipping_address?
          if @cart.update_attributes(params[:cart])
            redirect_to checkout_payment_url and return
          else
            prepare_show_view
            render :show
          end
        else
          Store::Cart::AddressDefinition.new(self, @cart).use_users_default_address
          redirect_to checkout_payment_url and return
        end
      end

      private

      def prepare_show_view
        @cart.build_shipping_address
        @customer_address = @cart.user.default_address
      end

      def use_custom_shipping_address?
        params[:place_order_with_custom_shipping_address] == "1"
      end

      def define_cart_persistence
        @cart = cart.persistence
      end
    end
  end
end

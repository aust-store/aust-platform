module Store
  module Checkout
    class SuccessController < Store::CheckoutBaseController
      def show
        @order_id = session[:last_order_id]
      end
    end
  end
end

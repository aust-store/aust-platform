module Store
  module Checkout
    class SuccessController < Store::ApplicationController
      def show
        @order_id = session[:last_order_id]
      end
    end
  end
end

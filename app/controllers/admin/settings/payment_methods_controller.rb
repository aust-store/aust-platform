module Admin
  module Settings
    class PaymentMethodsController < Admin::ApplicationController
      def show
        @gateway = current_company.payment_gateway ||
          current_company.build_payment_gateway(name: :pagseguro)
      end
    end
  end
end

module Store
  module GatewayNotifications
    class PagseguroController < Store::ApplicationController
      def create
        email = current_store.payment_gateway.email
        token = current_store.payment_gateway.token
        notification_code = params[:notificationCode]

        pagseguro_response = PagSeguro::Notification.new(email, token, notification_code)
        notification = Store::GatewayNotifications::PagseguroWrapper.new(pagseguro_response)

        Store::Order::StatusChange.change(notification)

        render nothing: true
      end
    end
  end
end

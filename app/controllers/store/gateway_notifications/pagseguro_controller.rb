module Store
  module GatewayNotifications
    class PagseguroController < ActionController::Base
      def create
        email = "email"
        token = "token"
        notification_code = params[:notificationCode]

        pagseguro_response = PagSeguro::Notification.new(email, token, notification_code)
        notification = Store::GatewayNotifications::PagseguroWrapper.new(pagseguro_response)

        Store::Order::StatusChange.change(notification)

        render nothing: true
      end
    end
  end
end

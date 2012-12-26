module Store
  module GatewayNotifications
    class UndefinedInterface < StandardError; end

    class Base
      def initialize(notification)
        @notification = notification
        @status = nil
      end

      def order_id
        raise UndefinedInterface, "#order_id is not defined"
      end

      def unique_id_within_gateway
        raise UndefinedInterface, "#unique_id_within_gateway is not defined"
      end

      def status
        raise UndefinedInterface, "#status is not defined"
      end
    end
  end
end

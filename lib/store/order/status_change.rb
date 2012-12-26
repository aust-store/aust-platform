module Store
  module Order
    class StatusChange
      attr_reader :notification

      def initialize(notification)
        @notification = notification
      end

      def self.change(notification)
        new(notification).change
      end

      def change
        status_log.set_status_as(notification.status)
      end

      private

      def unique_id_within_gateway
        notification.unique_id_within_gateway
      end

      def order
        @order ||= ::Order.find(notification.id)
      end

      def status_log
        @status ||= PaymentStatus.new(
          notification_id: unique_id_within_gateway, order: order
        )
      end
    end
  end
end

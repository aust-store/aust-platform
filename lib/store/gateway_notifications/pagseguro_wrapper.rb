module Store
  module GatewayNotifications
    class PagseguroWrapper < Store::GatewayNotifications::Base
      def order_id
        @notification.id
      end

      def unique_id_within_gateway
        @notification.transaction_id
      end

      def status
        if    @notification.processing?  then :processing
        elsif @notification.approved?    then :approved
        elsif @notification.in_analysis? then :in_analysis
        elsif @notification.available?   then :available_for_withdrawal
        elsif @notification.disputed?    then :disputed
        elsif @notification.returned?    then :refunded
        elsif @notification.cancelled?   then :cancelled
        end
      end
    end
  end
end

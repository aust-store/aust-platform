module Store
  module Statistics
    class OnlineSales
      def initialize(company)
        @company = company
      end

      def today
        company
          .orders
          .created_on_the_website
          .joins(:items)
          .where("orders.created_at >= ?", Time.zone.now.beginning_of_day)
          .sum("order_items.price")
      end

      def this_month
        company
          .orders
          .created_on_the_website
          .joins(:items)
          .where("orders.created_at >= ?", Time.zone.now.beginning_of_month)
          .sum("order_items.price")
      end

      def last_thirty_days
        company
          .orders
          .created_on_the_website
          .joins(:items)
          .where("orders.created_at >= ?", 30.days.ago)
          .sum("order_items.price")
      end

      private

      attr_reader :company
    end
  end
end

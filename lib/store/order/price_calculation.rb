require "bigdecimal"

module Store
  module Order
    class PriceCalculation
      def initialize(order, items)
        @order = order
        @items = items
      end

      def total(payment_type = :cash)
        return 0 unless items.respond_to? :each
        payment_type = (payment_type || :cash).to_sym

        total = items.reduce(0) do |sum, item|
          if payment_type == :installments
            sum + (item.price_for_installments || item.price)
          else
            sum + item.price
          end
        end
        BigDecimal(total.to_s)
      end

      attr_reader :order, :items
    end
  end
end

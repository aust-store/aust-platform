# TODO - this DomainObject namespace is non-sense
require "bigdecimal"

module Store
  module DomainObject
    class Balance
      def initialize(balances)
        @balances = balances
      end

      def moving_average_cost
        if total_cost > 0
          total_cost / total_quantity 
        else
          BigDecimal("0.0")
        end
      end

      def total_quantity
        @balances.reduce(BigDecimal("0.0")) { |sum, e| sum + BigDecimal(e.quantity.to_s) }
      end

      def total_cost
        @balances.reduce(BigDecimal("0.0")) { |sum, e| BigDecimal(sum.to_s) + (BigDecimal(e.quantity.to_s) * BigDecimal(e.cost_per_unit.to_s)) }
      end
    end
  end
end

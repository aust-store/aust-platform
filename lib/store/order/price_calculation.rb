require "bigdecimal"

module Store
  module Order
    class PriceCalculation
      def self.calculate(items)
        return 0 unless items.respond_to? :each
        total = items.reduce(0) { |sum, i| sum + i.price }
        BigDecimal(total.to_s)
      end
    end
  end
end

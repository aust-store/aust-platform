require "bigdecimal"

module Store
  class Cart
    class PriceCalculation
      def self.calculate(items)
        return 0 unless items.kind_of? Array
        total = items.reduce(0) { |sum, i| sum + i.price }
        BigDecimal(total.to_s)
      end
    end
  end
end

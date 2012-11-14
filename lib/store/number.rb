require "bigdecimal"

module Store
  class Number
    def initialize(number)
      @number = BigDecimal.new(number.to_s)
    end

    def remove_zeros
      number = @number.to_s("F")
      number.gsub(/[0]{1,}$/, "").gsub(/[\.|,]$/, "")
    end
  end
end

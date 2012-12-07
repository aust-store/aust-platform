# encoding: utf-8
require "bigdecimal"

module Store
  class Money
    def initialize(amount, currency = "R$")
      @amount = BigDecimal.new(amount.to_s)
      @currency = currency
    end

    def to_s
      amount = format_number
      "#{@currency} #{amount}"
    end

    private

    def format_number
      amount = @amount.to_s("F").to_s
      amount = amount.gsub(/[\.|,]/, ',')
      amount = amount.gsub(/[\.|,]([0-9]{0,2})$/, ',\1')
      amount = amount.gsub(/[\.|,]([0-9]{2}).*/, ',\1')
      amount = amount.gsub(/,([0-9]{1})$/, ',\10')
      amount
    end
  end
end

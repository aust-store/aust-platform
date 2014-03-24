require "bigdecimal"
class Money
  attr_reader :amount, :currency

  def initialize(amount, currency = "R$")
    @amount   = amount.to_f
    @currency = currency
  end

  def to_f
    @amount
  end

  def to_s
    @amount.to_s
  end

  def ==(value)
    @amount == value
  end

  def +(value)
    value = value.to_f if value.respond_to?(:to_f)
    value = (BigDecimal(@amount.to_s) + value).round(2)
    Money.new(value)
  end

  def *(value)
    value = value.to_f if value.respond_to?(:to_f)
    value = (BigDecimal(@amount.to_s) * value).round(2)
    Money.new(value)
  end

  def humanize
    if currency == "R$"
      "R$ #{format_amount}"
    end
  end

  private

  def format_amount
    amount = @amount.to_s
    amount = amount.gsub(/[\.|,]/, ',')
    amount = amount.gsub(/[\.|,]([0-9]{0,2})$/, ',\1')
    amount = amount.gsub(/[\.|,]([0-9]{2}).*/, ',\1')
    amount = amount.gsub(/,([0-9]{1})$/, ',\10')
    amount = amount.reverse.gsub(/...(?=.)/,'\&.').reverse
    amount = amount.gsub(/\.,/, ',')
    amount
  end
end

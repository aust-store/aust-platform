require "./lib/store/currency"

module CurrencyParser
  def to_float!
    replace ::Store::Currency.to_float(self).to_s
  end
end

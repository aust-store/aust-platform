class Money
  attr_reader :amount, :currency

  def initialize(amount, currency = "R$")
    @amount   = amount.to_f
    @currency = currency
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

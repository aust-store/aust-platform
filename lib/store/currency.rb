require 'bigdecimal'

module Store
  class Currency
    def self.to_float value
      return false unless value.kind_of?(String)
      value.gsub!(/[%|\s|A-Za-z]/, '')

      # nn.nnn.nn
      value = if (value =~ /[\.|,]\d{2}$/).nil? == false
        value.gsub(/\.|,/, 'x').gsub(/x/, "").gsub(/(\d{2})$/, '.\1')
      # nn.nnn.n
      elsif (value =~ /[\.|,]\d{1}$/).nil? == false
        value.gsub(/\.|,/, 'x').gsub(/x/, "").gsub(/(\d{1}$)/, '.\10')
      # nn.nnnn
      else
        value.gsub(/[^0-9]/, '').to_s + ".00"
      end
      # TODO - BigDecimal?
      value.gsub(/[^0-9|\.]/, '').to_f
    end
  end
end

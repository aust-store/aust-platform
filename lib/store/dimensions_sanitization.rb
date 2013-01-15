# encoding: utf-8
require "bigdecimal"

module Store
  class DimensionsSanitization

    def self.sanitize(value)
      result = value.to_s.gsub(/[^0-9|\.|,]/, "")

      if result.scan(",").count + result.scan(".").count == 1 and
      !(result =~ /[\.|,]\d{2}$/).nil? == false and
      !(result =~ /[\.|,]\d{1}$/).nil? == false

        result = result.gsub(/[^0-9]/, "")
      else
        result = result.gsub(/([\.|,])([0-9]{1,9})$/, 'x\2')
        result = result.gsub(/[^0-9|x]/, "")
        result = result.gsub(/x/, ".")
      end

      result.to_f
    end
  end
end
# encoding: utf-8
require "bigdecimal"

module Store
  class NumberSanitizer

    def self.sanitize_number(number)
      number = number.to_s.gsub(/[a-zA-Z]/, "")
                          .gsub(/[\.|,]$/,  "")
                          .gsub(/[0]{1,}$/, "")
    end
  end
end
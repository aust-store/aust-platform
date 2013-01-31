module Store
  class ZipcodeSanitization
    def self.sanitize_zipcode(zipcode)
      zipcode.to_s.gsub(/[^0-9]/, "").to_i
    end
  end
end
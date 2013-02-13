module Store
  module Company
    class DomainSanitizer
      def initialize(domain)
        @domain = domain
      end

      def sanitize
        domain = @domain.is_a?(String) ? @domain : ""
        domain.strip!
        domain.gsub!(/http:[\/]{0,2}/, "") # removes http
        domain.gsub!(/\A[www]{0,3}\./, "") # removes www
        domain.gsub!(/\A\./, "")           # . at the beginning
        domain.gsub!(/\?(.*)\Z/, "")       # ?key=value at the end
        domain.gsub!(/\//, "")             # removes any /
        domain.gsub!(/[^0-9|a-z|A-Z|.|\-|_]/,  "") # removes anything invalid
        domain.gsub!(/[^a-z|A-Z]\Z/, "")   # anything except letters at the end
        domain.gsub!(/\-\Z/, "")           # removes - at the end
        domain
      end
    end
  end
end

module Models
  module Extensions
    module FullTextSearch
      def search(&block)
        @fields   = []
        @keywords = nil

        yield if block_given?

        options = {
          fields:   @fields,
          keywords: @keywords
        }
        PostgresSearch::Search.new(self, options).search
      end

      def fields(*args)
        @fields = Array(args)
      end

      def keywords(keywords)
        @keywords = keywords
      end
    end
  end
end

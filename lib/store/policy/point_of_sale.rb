module Store
  module Policy
    class PointOfSale
      def initialize(company)
        @company = company
      end

      def enabled?
        true
      end

      private

      attr_accessor :company
    end
  end
end

module ShippingCalculation
  module Correios
    class ZipcodeValidation
      def initialize(zipcode)
        @company_zipcode   = zipcode
        @correios_response = correios_response
      end

      def invalid_origin_zipcode?
        @correios_response.error == -2
      end

      def correios_system_unavailable?
        @correios_response.error == -33
      end

      def unexpected_error?
        ![0, -33, -2].include?(@correios_response.error)
      end

      private

      def correios_response
        options = {
          source_zipcode:      @company_zipcode,
          destination_zipcode: 96360000,
          items:               [fake_item],
          shipping_type:       :pac
        }
        ::ShippingCalculation::Correios::Calculation.new(options).calculate
      end

      def fake_item
        item = Struct.new(:weight, :length, :width, :height)
        item.new(0.4, 23, 23, 23)
      end
    end
  end
end

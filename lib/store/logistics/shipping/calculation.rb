module Store
  module Logistics
    module Shipping
      class Calculation
        def initialize(options)
          @source_zipcode      = options[:source_zipcode]
          @destination_zipcode = options[:destination_zipcode]
          @items               = options[:items]
          @country             = options[:country]
          @shipping_type       = options[:shipping_type]
        end

        def calculate
          options = {
            source_zipcode:      @source_zipcode,
            destination_zipcode: @destination_zipcode,
            items:               @items,
            shipping_type:       @shipping_type
          }
          processor.new(options).calculate
        end

        private

        attr_reader :country

        def processor
          @processor ||= "ShippingCalculation::#{country_processor}::Calculation".constantize
        end

        def country_processor
          { "BR" => "Correios" }[country]
        end
      end
    end
  end
end

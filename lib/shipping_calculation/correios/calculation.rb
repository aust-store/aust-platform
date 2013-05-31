# Using the Correios gem
#
#  => https://github.com/brunofrank/correios
module ShippingCalculation
  module Correios
    class Calculation

      # options example
      #
      #   => { source_zipcode:      "111",
      #        destination_zipcode: "222",
      #        items:               items,
      #        shipping_type:       "BR" }
      #
      #  `items` is an array of items responding to weight, length, height and
      #  width.
      #
      def initialize(options)
        @source_zipcode      = options[:source_zipcode]
        @destination_zipcode = options[:destination_zipcode]
        @items               = options[:items]
        @shipping_type       = options[:shipping_type]
      end

      def calculate
        correios = ::Correios.new(source_zipcode, destination_zipcode)

        calculations = []
        # TODO
        # we can improve these calculations by assuming Correios limits
        # instead of just calculating a value for each item
        #
        # e.g the store own could use one box to have more than one item
        items.each do |e|
          calculations << correios.calcular_frete(types[shipping_type.to_s],
                                                  e.weight.to_i,
                                                  e.length.to_i,
                                                  e.height.to_i,
                                                  e.width.to_i)
        end

        calculation_results(calculations)
      end

      private

      attr_reader :source_zipcode, :destination_zipcode, :items, :shipping_type

      def calculation_results(results_for_each_item)
        results = results_for_each_item.map do |result|
          ::ShippingCalculation::Correios::Item.new(result)
        end
        ::Store::Logistics::Shipping::Response.new(results)
      end

      def types
        { "pac" => ::Correios::Servico::PAC, "sedex" => ::Correios::Servico::SEDEX }
      end
    end
  end
end

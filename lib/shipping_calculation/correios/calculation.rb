# Using the Correios-Frete gem
#
#  => https://github.com/prodis/correios-frete
module ShippingCalculation
  module Correios
    class Calculation

      # options example
      #
      #   => { source_zipcode:      "111",
      #        destination_zipcode: "222",
      #        items:               items,
      #        shipping_type:       :pac }
      #
      #  `items` is an array of items responding to weight, length, height and
      #  width.
      #
      #  :pac is a shipping type in Correios (Brazil)
      #
      def initialize(options)
        @source_zipcode      = options[:source_zipcode]
        @destination_zipcode = options[:destination_zipcode]
        @items               = options[:items]
        @shipping_type       = options[:shipping_type]
      end

      def calculate
        calculation = ::Correios::Frete::Calculador.new(
          cep_origem:  source_zipcode,
          cep_destino: destination_zipcode,
          encomenda:   package
        )
        result = calculation.calcular(shipping_type.to_sym)
        ::ShippingCalculation::Correios::Response.new(result)
      end

      private

      attr_reader :source_zipcode, :destination_zipcode, :items, :shipping_type

      def package
        package = ::Correios::Frete::Pacote.new
        items.map do |item|
          item_package = ::Correios::Frete::PacoteItem.new(
            peso:        item.weight,
            comprimento: item.length.to_i,
            largura:     item.width.to_i,
            altura:      item.height.to_i
          )
          package.add_item(item_package)
        end
        package
      end
    end
  end
end

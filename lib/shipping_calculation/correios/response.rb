module ShippingCalculation
  module Correios
    class Response
      attr_reader :shipping_type, :destination_zipcode
      def initialize(result, package, shipping_type, destination_zipcode)
        @result  = result
        @package = package
        @shipping_type = shipping_type
        @destination_zipcode = destination_zipcode
      end

      def total
        @result.valor
      end

      def days
        @result.prazo_entrega
      end

      def success?
        @result.sucesso?
      end

      def package_width
        @package.largura
      end

      def package_height
        @package.altura
      end

      def package_length
        @package.comprimento
      end

      def package_weight
        @package.peso
      end

      def error
        @result.erro.to_i
      end

      def type
        @shipping_type
      end

      def company_name
        :correios
      end

      def error_message
        return false if success?
        @result.msg_erro
      end
    end
  end
end

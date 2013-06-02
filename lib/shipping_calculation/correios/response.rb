module ShippingCalculation
  module Correios
    class Response
      def initialize(result, package)
        @result  = result
        @package = package
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

      def width
        @package.largura
      end

      def height
        @package.altura
      end

      def length
        @package.comprimento
      end

      def weight
        @package.peso
      end

      def error
        @result.erro.to_i
      end

      def error_message
        return false if success?
        @result.msg_erro
      end
    end
  end
end

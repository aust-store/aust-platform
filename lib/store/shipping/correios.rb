module Store
  module Shipping
    class Correios
      def initialize(resource)
        @resource = resource
      end

      def cost
        @resource.valor
      end

      def days
        @resource.prazo
      end

      def success?
        @resource.erro >= 0
      end

      def message
        @resource.message
      end
    end
  end
end

module Store
  module Shipping
    module Correios
      class Response
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
          @resource.erro == 0
        end

        def message
          @resource.message
        end

        def error
          @resource.erro
        end
      end
    end
  end
end

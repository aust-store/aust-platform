module Store
  module Shipping
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
          resource = ::Correios.new(@company_zipcode, 96360000)
            .calcular_frete(::Correios::Servico::PAC, 0.4, 23, 23, 23)
          Store::Shipping::Correios::Response.new(resource)
        end
      end
    end
  end
end
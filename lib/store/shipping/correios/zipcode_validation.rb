module Store
  module Shipping
    module Correios
      class ZipcodeValidation
        def initialize(company_zipcode)
          @company_zipcode = company_zipcode
          @correios_response = correios_response
        end

        def invalid_origin_zipcode?
          @correios_response.erro == -2
        end

        def correios_system_unavailable?
          @correios_response.erro == -33
        end

        def unexpected_error?          
          [0, -33, -2].all? do |error_code|
            @correios_response.erro != error_code
          end
        end

        private

        def correios_response
          ::Correios.new(@company_zipcode, 96360000)
            .calcular_frete(::Correios::Servico::PAC, 0.4, 23, 23, 23)
        end
      end
    end
  end
end
module Store
  module Shipping
    module Correios
      class ZipcodeValidation
        def initialize(company_zipcode)
          @company_zipcode = company_zipcode
          @correios_response = correios_response
        end

        def success?
          @correios_response.erro == 0
        end

        private

        def correios_response
          ::Correios.new(@company_zipcode, 96360000)
            .calcular_frete(::Correios::Servico::PAC, 12, 23, 23, 23)
        end
      end
    end
  end
end
module Store
  module Shipping
    class Calculation
      def initialize(controller, country = :br)
        @controller = controller
        @country = country
      end

      def enabled?
        store.has_zipcode?
      end

      def calculate(client_zipcode, type)
        type = type.to_sym
        company_zipcode = store.zipcode
        correios = ::Correios.new(company_zipcode, client_zipcode)

        calculations = []
        # TODO
        # we can improve these calculations by assuming Correios limits
        # instead of just calculating a value for each item
        #
        # e.g the store own could use one box to have more than one item
        items_dimensions.each do |e|
          calculations << correios.calcular_frete(types[type],
                                                  e.weight.to_i,
                                                  e.length.to_i,
                                                  e.height.to_i,
                                                  e.width.to_i)
        end

        calculation_results(calculations)
      end

      def items_dimensions
        items
      end

      private

      def calculation_results(results_for_each_item)
        results = results_for_each_item.map do |result|
          ::Store::Shipping::Correios.new(result)
        end
        CalculationResult.new(results)
      end

      def store
        @controller.current_store
      end

      def items
        @controller.cart_items_dimensions
      end

      def types
        { pac: ::Correios::Servico::PAC, sedex: ::Correios::Servico::SEDEX }
      end
    end
  end
end

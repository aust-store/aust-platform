module Store
  module Logistics
    module Shipping
      class Response
        def initialize(results)
          @results = results
        end

        def total
          amount = 0
          @results.each do |result|
            amount += result.cost
          end
          amount
        end

        def days
          @results.inject(0) { |greater, e| e.days > greater ? e.days : greater }
        end

        def success?
          @results.all? { |e| e.success? }
        end

        def error_message
          return false if success?
          @results.first.message
        end
      end
    end
  end
end

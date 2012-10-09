module Store
  class Cart
    class Update
      def initialize(cart)
        @cart = cart
      end

      def update(params)
        params = sanitize_quantities(params)
        update_quantities(params) if params.has_key?("item_quantities")
      end

    private

      def persistence
        @cart.persistence
      end

      def update_quantities(params)
        persistence.update_quantities_in_batch(params["item_quantities"])
      end

      def sanitize_quantities(params)
        return params unless params.has_key?("item_quantities")
        item_quantities = params["item_quantities"]
        item_quantities = item_quantities.each_with_object({}) do |(key, value), sum|
          sum[key] = value.to_i
        end
        params["item_quantities"] = item_quantities
        params
      end
    end
  end
end

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
        quantities = params["item_quantities"]
        persistence.items.each do |item|
          if quantities.has_key?(item.id.to_s)
            item.update_quantity(quantities[item.id.to_s].to_i)
          end
        end
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

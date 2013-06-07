module Store
  class CartShippingCalculation
    def initialize(controller, country = "BR")
      @controller = controller
      @country = country
    end

    def self.create(controller, country = "BR")
      new(controller, country).create
    end

    def create
      options = {
        source_zipcode:      source_zipcode,
        destination_zipcode: destination_zipcode,
        items:               items,
        shipping_type:       type,
        country:             @country
      }
      calculation = ::Store::Logistics::Shipping::Calculation.new(options)
      result = calculation.calculate

      cart.update_shipping(result) if result.success?

      result
    end

    private

    def cart
      @controller.cart.persisted_cart
    end

    def items
      @controller.cart_items_dimensions
    end

    def source_zipcode
      @controller.current_store.zipcode
    end

    def destination_zipcode
      @controller.params[:zipcode]
    end

    def type
      @controller.params[:type]
    end
  end
end

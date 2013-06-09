module Store
  class CartShippingCalculation
    def initialize(controller, options)
      @controller = controller
      @options    = options
    end

    def self.create(controller, options)
      new(controller, options).create
    end

    def create
      params = {
        source_zipcode:      source_zipcode,
        destination_zipcode: options[:destination_zipcode],
        items:               items,
        shipping_type:       options[:type],
        country:             country
      }
      calculation = ::Store::Logistics::Shipping::Calculation.new(params)
      result = calculation.calculate

      cart.update_shipping(result) if result.success?

      result
    end

    private

    attr_reader :options

    def cart
      @controller.cart.persisted_cart
    end

    def items
      cart.items_shipping_boxes
    end

    def source_zipcode
      @controller.current_store.zipcode
    end

    def country
      @controller.current_store.country
    end
  end
end

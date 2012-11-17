module Store
  class ShippingCalculation
    def initialize(source_zipcode, destination_zipcode)
      @source_zipcode = source_zipcode
      @destination_zipcode = destination_zipcode
    end
  end
end

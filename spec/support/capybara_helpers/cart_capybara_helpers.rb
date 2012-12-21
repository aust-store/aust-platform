module CapybaraHelpers
  module CartHelpers
    def stub_shipping
      stubbed_shipping = double(success?: true, total: 12.34, days: 3)
      Store::Shipping::CartCalculation.stub(:create) { stubbed_shipping }
    end

    def stub_shipping_calculation_enabled (status)
      shipping_calculation = double(enabled?: status)
      Store::Shipping::Calculation.stub(:new) { shipping_calculation }  
    end
  end
end

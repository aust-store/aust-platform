module CapybaraHelpers
  module CartHelpers
    def stub_shipping
      stubbed_shipping = double(success?: true, total: 12.34, days: 3)
      Store::Logistics::Shipping::Calculation
        .any_instance.stub(:calculate) { stubbed_shipping }
    end
  end
end

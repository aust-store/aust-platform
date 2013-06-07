module CapybaraHelpers
  module CartHelpers
    def stub_shipping
      stubbed_shipping = double(success?: true,
                                total:  12.34,
                                package_weight: 0.4,
                                package_height: 23,
                                package_width:  23,
                                package_length: 23,
                                type: :pac,
                                company_name: :correios,
                                destination_zipcode: "86960000",
                                days:   3)
      ::Store::Logistics::Shipping::Calculation
        .any_instance.stub(:calculate) { stubbed_shipping }
    end
  end
end

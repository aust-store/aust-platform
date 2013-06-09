module CapybaraHelpers
  module CartHelpers
    def stub_shipping(zipcode = "96360000")
      stubbed_shipping = double(success?: true,
                                total:  111.23,
                                package_weight: 0.4,
                                package_height: 23,
                                package_width:  23,
                                package_length: 23,
                                type: :pac,
                                company_name: :correios,
                                destination_zipcode: zipcode,
                                days:   3)
      ::Store::Logistics::Shipping::Calculation
        .any_instance.stub(:calculate) { stubbed_shipping }
    end
  end
end

module CapybaraHelpers
  module CartHelpers
    def stub_shipping(options = {})
      options[:destination_zipcode] = options.fetch(:zipcode,        "96360000")
      options[:total]          = options.fetch(:total,          111.23)
      options[:package_weight] = options.fetch(:package_weight, 0.4)
      options[:package_height] = options.fetch(:package_height, 23)
      options[:package_width]  = options.fetch(:package_width,  23)
      options[:package_length] = options.fetch(:package_length, 23)
      options[:success?]       = options.fetch(:success?,       true)
      options[:type]           = options.fetch(:type,           :pac)
      options[:company_name]   = options.fetch(:company_name,   :correios)
      options[:days]           = options.fetch(:days,           3)
      stubbed_shipping = double(options)
      ::Store::Logistics::Shipping::Calculation
        .any_instance.stub(:calculate) { stubbed_shipping }
    end
  end
end

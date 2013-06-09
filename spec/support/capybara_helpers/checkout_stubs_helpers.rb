module CapybaraHelpers
  module CheckoutStubsHelpers
    def stub_payment_gateway(options = {redirect_to: checkout_success_path})
      ::PagSeguro::Payment.any_instance.stub(:checkout_payment_url) do
        options[:redirect_to]
      end
    end
  end
end

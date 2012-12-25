require "spec_helper"
require 'store/payment/pagseguro/checkout'

describe Store::Payment::Pagseguro::Checkout do
  it_obeys_the "cart contract"
  it_obeys_the "cart item contract"

  let(:shipping_address) { FactoryGirl.build(:address) }
  let(:shipping_options) { double(service_type: 'pac') }
  let(:user)             { FactoryGirl.create(:user) }
  let(:items)            { [double(id: 1, name: "T-Shirt", price: 12.0, quantity: 2)] }
  let(:controller)       { double(return_urls: {pagseguro: "http://www.uol.com.br"}) }

  let(:order)            { double(id:               2,
                                  shipping_address: shipping_address,
                                  shipping_options: shipping_options,
                                  user:             user,
                                  all_items:        items) }

  describe "#create_transaction" do
    it "contacts PagSeguro and returns the payment URL" do
      payment = described_class.new(controller, order)
      payment.create_transaction
      url = payment.payment_url
      url.should include 'https://pagseguro.uol.com.br/v2/checkout/payment.html?code='
      url.should =~ /\?code=.{32}/ 
    end
  end
end

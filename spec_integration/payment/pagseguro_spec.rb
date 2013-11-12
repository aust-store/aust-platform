require "spec_helper"
require 'store/payment/pagseguro/checkout'

describe Store::Payment::Pagseguro::Checkout do
  it_obeys_the "cart contract"
  it_obeys_the "cart item contract"
  it_obeys_the "loading store contract"


  let(:shipping_address) { FactoryGirl.build(:address) }
  let(:shipping_options) { double(service_type: 'pac', price: 8.0) }
  let(:customer)         { FactoryGirl.create(:customer) }
  let(:items)            { [double(id: 1, name: "T-Shirt", price: 12.0, quantity: 2)] }

  let(:payment_gateway)  { double(email: "chavedomundo@gmail.com", token: "CCC1DB502E84406187718F205517E665") }
  let(:store)            { double(payment_gateway: payment_gateway) }
  let(:controller)       { double(current_store: store) }

  let(:order)            { double(id:               2,
                                  shipping_address: shipping_address,
                                  shipping_options: shipping_options,
                                  shipping_details: nil,
                                  customer:         customer,
                                  items:            items) }

  before do
    controller.stub(:after_payment_return_url).with(:pagseguro) { "http://www.uol.com.br" }
    items.stub(:parent_items) { items }
  end

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

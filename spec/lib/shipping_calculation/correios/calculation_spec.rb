require "unit_spec_helper"
require "shipping_calculation/correios/calculation"
require "shipping_calculation/correios/item"

class DummyCorreios
  class Servico
    PAC   = :pac
    SEDEX = :sedex
  end
end

describe ShippingCalculation::Correios::Calculation do
  it_should_behave_like "shipping processor"

  let(:item)     { double(length: 1, width: 2, height: 3, weight: 4) }
  let(:items)    { [item, item] }
  let(:pac)      { double }
  let(:correios) { double }
  let(:options) do
    { source_zipcode:      "123",
      destination_zipcode: "456",
      items:               items,
      shipping_type:       :pac }
  end

  subject { described_class.new(options) }

  before do
    stub_const("Correios", Class.new)
    stub_const("Correios::Servico::PAC",   pac)
    stub_const("Correios::Servico::SEDEX", Class.new)
    stub_const("Store::Logistics::Shipping::Response", Class.new)
    Correios.stub(:new).with("123", "456") { correios }
    correios.stub(:calcular_frete)
  end

  describe "#calculate" do
    it "returns an instance of the result wrapper" do
      correios
        .stub(:calcular_frete)
        .with(pac, 4, 1, 3, 2)
        .and_return(:result)

      ::ShippingCalculation::Correios::Item
        .stub(:new)
        .with(:result)
        .and_return(correios)

      ::Store::Logistics::Shipping::Response
        .should_receive(:new)
        .with([correios, correios])
        .and_return(:result_wrapper)

      subject.calculate.should == :result_wrapper
    end
  end
end

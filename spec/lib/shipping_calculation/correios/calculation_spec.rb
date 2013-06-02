require "unit_spec_helper"
require "shipping_calculation/correios/calculation"

class DummyCorreios
  class Servico
    PAC   = :pac
    SEDEX = :sedex
  end
end

describe ShippingCalculation::Correios::Calculation do
  it_should_behave_like "shipping processor"

  let(:item)         { double(length: 1, width: 2, height: 3, weight: 4) }
  let(:items)        { [item, item] }
  let(:correios)     { double(encomenda: :package) }
  let(:package)      { double }
  let(:item_package) { double }
  let(:options) do
    { source_zipcode:      "123",
      destination_zipcode: "456",
      items:               items,
      shipping_type:       :pac }
  end

  subject { described_class.new(options) }

  before do
    stub_const("Correios::Frete",             Class.new)
    stub_const("Correios::Frete::Calculador", Class.new)
    stub_const("Correios::Frete::Pacote",     Class.new)
    stub_const("Correios::Frete::PacoteItem", Class.new)
    stub_const("ShippingCalculation::Correios::Response", Class.new)
    Correios::Frete::Pacote.stub(:new) { package }
    Correios::Frete::PacoteItem
      .stub(:new)
      .with({peso: 4, comprimento: 1, largura: 2, altura: 3})
      .and_return(item_package)
  end

  describe "#calculate" do
    it "returns an instance of the result wrapper" do
      package.should_receive(:add_item).with(item_package).twice

      Correios::Frete::Calculador
        .stub(:new)
        .with({cep_origem:  "123",
               cep_destino: "456",
               encomenda:   package})
        .and_return(correios)

      correios
        .stub(:calcular)
        .with(:pac)
        .and_return(:result)

      ShippingCalculation::Correios::Response
        .should_receive(:new)
        .with(:result, :package)
        .and_return(:result_wrapper)

      subject.calculate.should == :result_wrapper
    end
  end
end

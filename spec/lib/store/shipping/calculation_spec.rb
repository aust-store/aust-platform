require "unit_spec_helper"
require "store/shipping/calculation"
require "store/shipping/calculation_result"
require "store/shipping/correios"

class DummyCorreios
  class Servico
    PAC   = :pac
    SEDEX = :sedex
  end
end

describe Store::Shipping::Calculation do
  it_should_behave_like "loading store contract"

  let(:store) { double(zipcode: "123") }
  let(:dimension) { double(length: 1, width: 2, height: 3, weight: 4) }
  let(:controller) do
    double(current_store: store, cart_items_dimensions: [dimension, dimension] )
  end
  let(:correios) { double }

  before do
    stub_const("Correios", DummyCorreios)
    DummyCorreios.stub(:new).with("123", "456") { correios }
  end

  describe "#calculate" do
    it "returns an instance of the result wrapper" do
      correios
        .should_receive(:calcular_frete)
        .with(:pac, 4, 1, 3, 2)
        .twice
        .and_return(:result)

      result = described_class.new(controller)

      Store::Shipping::Correios
        .stub(:new)
        .with(:result)
        .and_return(correios)

      Store::Shipping::CalculationResult
        .stub(:new)
        .with([correios, correios])
        .and_return(:result_wrapper)

      result.calculate("456", :pac).should == :result_wrapper
    end
  end

  describe "#items_dimensions" do
    it "returns an instance of the result wrapper" do
      result = described_class.new(controller).items_dimensions
      result.first.length.should == 1
      result.first.width.should == 2
      result.first.height.should == 3
      result.first.weight.should == 4
      result.last.length.should == 1
      result.last.width.should == 2
      result.last.height.should == 3
      result.last.weight.should == 4
    end
  end
end

require "store/shipping/correios/zipcode_validation"
class DummyCorreios
  class Servico
    PAC   = :pac
    SEDEX = :sedex
  end
end

describe Store::Shipping::Correios::ZipcodeValidation do
  let(:correios_response) { double }
  let(:correios) { double(success?: true, calcular_frete: correios_response)}

  before do
    stub_const("Correios", DummyCorreios)
    DummyCorreios.stub(:new).with(96360000, 96360000) { correios }
  end

  describe "#success?" do
    it "returns false if there's any error" do
      correios_response.stub(:erro) { -2 }
      described_class.new(96360000).success?.should == false
    end

    it "returns true if there's no error" do
      correios_response.stub(:erro) { 0 }
      described_class.new(96360000).success?.should == true
    end
  end
end
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

  describe "#invalid_origin_zipcode?" do
    it "returns true if the response returns the expected error" do
      correios_response.stub(:erro) { -2 }
      described_class.new(96360000).invalid_origin_zipcode?.should == true
    end

    it "returns false if the response doesn't returns the expected error" do
      correios_response.stub(:erro) { 2 }
      described_class.new(96360000).invalid_origin_zipcode?.should == false
    end
  end

  describe "#correios_system_unavailable?" do
    it "returns true if the response returns the expected error" do
      correios_response.stub(:erro) { -33 }
      described_class.new(96360000).correios_system_unavailable?.should == true
    end

    it "returns false if the response returns the expected error" do
      correios_response.stub(:erro) { 0 }
      described_class.new(96360000).correios_system_unavailable?.should == false
    end
  end

  describe "#unexpected_error?" do
    it "returns true if the response returns an unexpected error" do
      correios_response.stub(:erro) { -3 }
      described_class.new(96360000).unexpected_error?.should == true
    end

    it "returns false if the response returns an already known error" do
      correios_response.stub(:erro) { -33 }
      described_class.new(96360000).unexpected_error?.should == false
    end

    it "returns false if the response returns an already known error" do
      correios_response.stub(:erro) { -2 }
      described_class.new(96360000).unexpected_error?.should == false
    end
  end
end
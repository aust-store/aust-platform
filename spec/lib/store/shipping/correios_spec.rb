require "store/shipping/correios"

describe Store::Shipping::Correios do
  let(:correios_result) { double(valor: "123", erro: -22) }

  describe "#value" do
    it "returns the value" do
      result = described_class.new(correios_result)
      result.cost.should == "123"
    end
  end

  describe "#success?" do
    it "returns false if there's any error" do
      correios_result.stub(:erro) { -22 }
      result = described_class.new(correios_result)
      result.success?.should == false
    end

    it "returns true if there's no error" do
      correios_result.stub(:erro) { 0 }
      result = described_class.new(correios_result)
      result.success?.should == true
    end

    it "returns false if error number is greater than 0" do
      correios_result.stub(:erro) { 99 }
      result = described_class.new(correios_result)
      result.success?.should == false
    end
  end
end

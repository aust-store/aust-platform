require "shipping_calculation/correios/zipcode_validation"

describe ShippingCalculation::Correios::ZipcodeValidation do
  let(:correios_response) { double }
  let(:fake_item)         { double }
  let(:struct)            { double }
  let(:options) do
    { source_zipcode:      12345678,
      destination_zipcode: 96360000,
      items:               [fake_item],
      shipping_type:       :pac }
  end

  subject { described_class.new(12345678) }

  before do
    stub_const("ShippingCalculation::Correios::Calculation", Class.new)
    Struct.stub(:new) { struct }
    struct.stub(:new).with(0.4, 23, 23, 23) { fake_item }
    ::ShippingCalculation::Correios::Calculation
      .stub(:new)
      .with(options)
      .and_return(double(calculate: correios_response))
  end

  describe "#invalid_origin_zipcode?" do
    it "returns true if the response returns the expected error" do
      correios_response.stub(:error) { -2 }
      subject.invalid_origin_zipcode?.should == true
    end

    it "returns false if the response doesn't returns the expected error" do
      correios_response.stub(:error) { 2 }
      subject.invalid_origin_zipcode?.should == false
    end
  end

  describe "#correios_system_unavailable?" do
    it "returns true if the response returns the expected error" do
      correios_response.stub(:error) { -33 }
      subject.correios_system_unavailable?.should == true
    end

    it "returns false if the response returns the expected error" do
      correios_response.stub(:error) { 0 }
      subject.correios_system_unavailable?.should == false
    end
  end

  describe "#unexpected_error?" do
    it "returns true if the response returns an unexpected error" do
      correios_response.stub(:error) { -3 }
      subject.unexpected_error?.should == true
    end

    it "returns false if the response returns an already known error" do
      correios_response.stub(:error) { -33 }
      subject.unexpected_error?.should == false
    end

    it "returns false if the response returns an already known error" do
      correios_response.stub(:error) { -2 }
      subject.unexpected_error?.should == false
    end
  end
end

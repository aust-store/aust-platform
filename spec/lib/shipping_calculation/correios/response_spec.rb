require "shipping_calculation/correios/response"

describe ShippingCalculation::Correios::Response do
  let(:result)  { double }
  let(:package) { double }

  subject { described_class.new(result, package, :shipping_type, :destination_zipcode) }

  describe "#total" do
    it "returns the result amount" do
      result.stub(:valor) { 2 }
      subject.total.should == 2
    end
  end

  describe "#days" do
    it "returns the total days for the delivery" do
      result.stub(:prazo_entrega) { 2 }
      subject.days.should == 2
    end
  end

  describe "#success?" do
    it "returns the request status" do
      result.stub(:sucesso?) { 2 }
      subject.success?.should == 2
    end
  end

  describe "#error" do
    it "returns the error code" do
      result.stub(:erro) { "2" }
      subject.error.should == 2
    end
  end

  describe "#error_message" do
    before do
      result.stub(:msg_erro) { :error }
    end

    it "returns the error message if any" do
      subject.stub(:success?) { false }
      subject.error_message.should == :error
    end

    it "returns false if it was a successful request" do
      subject.stub(:success?) { true }
      subject.error_message.should == false
    end
  end

  describe "#package_weight" do
    before { package.stub(:peso) { 2 } }
    its(:package_weight) { should == 2 }
  end

  describe "#package_length" do
    before { package.stub(:comprimento) { 3 } }
    its(:package_length) { should == 3 }
  end

  describe "#package_height" do
    before { package.stub(:altura) { 4 } }
    its(:package_height) { should == 4 }
  end

  describe "#package_width" do
    before { package.stub(:largura) { 5 } }
    its(:package_width) { should == 5 }
  end
end

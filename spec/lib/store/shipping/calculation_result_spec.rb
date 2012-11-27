require "store/shipping/calculation_result"

describe Store::Shipping::CalculationResult do
  let(:result_one) { double(cost: 12.0, days: 4, success?: true) }
  let(:result_two) { double(cost: 17.55, days: 7, success?: true) }

  describe "#total" do
    it "returns the total amount considering all results" do
      result = described_class.new([result_one, result_two])
      result.total.should == 29.55
    end
  end

  describe "#days" do
    it "returns the greater number of days" do
      result = described_class.new([result_one, result_two])
      result.days.should == 7
    end
  end

  describe "#success?" do
    it "returns true if no errors happened" do
      result = described_class.new([result_one, result_two])
      result.success?.should == true
    end

    it "returns false if some errors happened" do
      result_one.stub(:success?) { false }
      result = described_class.new([result_one, result_two])
      result.success?.should == false
    end
  end

  describe "#error_message" do
    it "returns false if no errors happened" do
      result_one.stub(:message) { :message_one }
      result_two.stub(:message) { :message_two }
      result = described_class.new([result_one, result_two])
      result.error_message.should == false
    end

    it "returns the first error message, if any" do
      result_one.stub(:success?) { false }
      result_one.stub(:message) { :message_one }
      result_two.stub(:message) { :message_two }
      result = described_class.new([result_one, result_two])
      result.error_message.should == :message_one
    end
  end
end

require "money"

describe Money do
  describe "#amount" do
    it "returns 12.0 for 12.0" do
      described_class.new("12.0").amount.should == 12.0
    end
  end

  describe "#humanize" do
    context "brazilian currency" do
      it "adds zeros at the end if needed" do
        described_class.new(15.2).humanize.should == "R$ 15,20"
      end

      it "converts 15.24 to R$ 15,24" do
        described_class.new(15.24).humanize.should == "R$ 15,24"
      end

      it "adds decimals if needed" do
        described_class.new(15).humanize.should == "R$ 15,00"
      end

      it "removes extra decimals if needed" do
        described_class.new(15.123).humanize.should == "R$ 15,12"
      end

      it "removes extra decimals if needed" do
        described_class.new(15123).humanize.should == "R$ 15123,00"
      end
    end
  end
end

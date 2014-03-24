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
        described_class.new(15123).humanize.should == "R$ 15.123,00"
      end

      it "adds thousands separator" do
        described_class.new(15123555).humanize.should == "R$ 15.123.555,00"
      end
    end
  end

  describe "+" do
    it "calculates correctly" do
      result = Money.new(12.34) + 48.999
      result.should == Money.new(61.34) # 61.339
    end

    it "calculates money instances" do
      result = Money.new(12.34) + Money.new(48.999)
      result.should == Money.new(61.34) # 61.339
    end
  end

  describe "*" do
    it "calculates correctly" do
      result = Money.new(12.34) * 48
      result.should == Money.new(592.32) # 592.3199999
    end

    it "calculates two money instances" do
      result = Money.new(12.34) * Money.new(48)
      result.should == Money.new(592.32) # 592.3199999
    end
  end
end

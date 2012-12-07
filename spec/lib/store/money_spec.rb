require "store/money"

describe Store::Money do
  describe "#remove_zeros" do
    it "adds zeros at the end if needed" do
      Store::Money.new(15.2).to_s.should == "R$ 15,20"
    end

    it "converts 15.24 to R$ 15,24" do
      Store::Money.new(15.24).to_s.should == "R$ 15,24"
    end

    it "adds decimals if needed" do
      Store::Money.new(15).to_s.should == "R$ 15,00"
    end

    it "removes extra decimals if needed" do
      Store::Money.new(15.123).to_s.should == "R$ 15,12"
    end

    it "removes extra decimals if needed" do
      Store::Money.new(15123).to_s.should == "R$ 15123,00"
    end
  end
end

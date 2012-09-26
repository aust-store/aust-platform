# encoding: utf-8
require 'store/currency'

describe Store::Currency do
  describe "currency to float" do
    it "should convert these values" do
      Store::Currency.to_float("R$ 50,00").should  == 50.00
      Store::Currency.to_float("50.0").should      == 50.00
      Store::Currency.to_float("50.00").should     == 50.00
      Store::Currency.to_float("50.000,00").should == 50000.00
    end

    it "should convert values with letter in it" do
      Store::Currency.to_float("R$ 5aver0.0ddd0").should == 50.0
    end

    it "should return 0 if empty value" do
      Store::Currency.to_float("").should == 0
    end
  end
end


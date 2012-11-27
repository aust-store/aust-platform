require "spec_helper"

describe Company do
  describe "#zipcode" do
    it "returns the company zipcode" do
      company = Company.new
      company.stub(:settings) { double(zipcode: "123") }
      company.zipcode.should == "123"
    end
  end
end

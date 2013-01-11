require "store/number_sanitizer"
#require "contracts/lib/store/number_contract"

describe Store::NumberSanitizer do
  #it_should_behave_like "Store Number contract"

  describe "#sanitize_number" do
    it "it removes letters of the values" do
      Store::NumberSanitizer.sanitize_number("105,0710cm").should == "105,071"
    end
  end
end
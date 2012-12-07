require "store/number"
require "contracts/lib/store/number_contract"

describe Store::Number do
  it_should_behave_like "Store Number contract"

  describe "#remove_zeros" do
    it "it removes zeros at the end of the value as well as the dot," do
      Store::Number.new(15.0).remove_zeros.should == "15"
    end

    it "it removes zeros at the end of the value" do
      Store::Number.new(15.01230).remove_zeros.should == "15.0123"
    end
  end
end

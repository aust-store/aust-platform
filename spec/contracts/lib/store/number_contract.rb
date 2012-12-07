require "store/number"

shared_examples_for "Store Number contract" do
  describe Store::Number do
    it "responds to remove_zeros" do
      expect do
        Store::Number.new(15.0).remove_zeros.should == "15"
      end.to_not raise_error NoMethodError
    end
  end
end

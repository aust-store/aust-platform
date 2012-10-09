require "store/cart/update"

shared_examples_for "cart update contract" do
  describe "Cart Update object" do
    subject { Store::Cart::Update.new(double) }

    it "responds to update" do
      expect do
        subject.stub(:update_quantities)
        subject.update(double.as_null_object)
      end.to_not raise_error
    end
  end
end

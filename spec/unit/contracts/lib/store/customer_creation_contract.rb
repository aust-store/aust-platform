require "store/customer_creation"

shared_examples_for "CustomerCreation contract" do
  subject { Store::CustomerCreation }

  it "responds to create with two arguments" do
    expect do
      subject.create(123, 1, double.as_null_object)
    end.to_not raise_error
  end
end

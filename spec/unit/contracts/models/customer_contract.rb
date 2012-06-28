require "models/customer"

shared_examples_for "Customer contract" do
  subject { Good }

  it "responds to within_company" do
    expect do
      subject.within_company(123)
    end.to_not raise_error
  end

  it "responds to find" do
    expect do
      subject.find(123)
    end.to_not raise_error
  end

  it "responds to new" do
    expect do
      subject.new
    end.to_not raise_error
  end
end

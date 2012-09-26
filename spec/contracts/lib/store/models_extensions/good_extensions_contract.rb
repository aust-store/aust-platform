require "store/models_extensions/good"

class DummyGood
  include ::Store::ModelsExtensions::Good
end

shared_examples_for "Good model extension contract" do
  subject { DummyGood }

  it "responds to create with two arguments" do
    DummyGood.stub(:find) { double(images: double(build: :build)) }
    expect do
      subject.find_and_build_image(123)
    end.to_not raise_error
  end
end

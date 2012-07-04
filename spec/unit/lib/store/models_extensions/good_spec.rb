require "store/models_extensions/good"

class DummyGood
  include ::Store::ModelsExtensions::Good
end

describe DummyGood do
  it "finds item by id" do
    images = double
    good = double(images: images)
    images.should_receive(:build)
    DummyGood.stub(:find).with(1) { good }
    DummyGood.find_and_build_image(1)
  end
end

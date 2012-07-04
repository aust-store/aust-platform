require "unit_spec_helper"
require "controllers/admin/goods/images_controller"

describe Admin::Goods::ImagesController do
  subject { described_class.new }

  it_obeys_the "Good model extension contract"
  it_obeys_the "application controller contract"

  describe "#index" do
    before do
      subject.stub(:params) { {good_id: 12} }
    end

    it "should find the respective good and build its image" do
      Good.should_receive(:find_and_build_image).with(12)
      subject.index
    end
  end
end

require 'unit_spec_helper'
require "decorators/admin/good_decorator"

describe Admin::GoodDecorator do
  let(:good) { double.as_null_object }
  subject { Admin::GoodDecorator.new(good) }

  it_obeys_the "admin good decorator contract"

  before do
    subject.stub(:good) { good }
  end

  describe "#has_images?" do
    it "should return true if images are present" do
      good.stub_chain(:images, :present?) { true }
      subject.has_image?.should be_true
    end

    it "should return false if images aren't present" do
      good.stub_chain(:images, :present?) { false }
      subject.has_image?.should be_false
    end
  end
end

require 'spec_helper'

describe Banner do
  it { should belong_to :company }

  describe "validations" do
    it { should validate_presence_of :image }
    it { should validate_presence_of :position }

    describe "url validation" do
      it "doesn't validate nil URLs" do
        build(:banner, url: nil).should be_valid
      end

      it "prevents bad URLs" do
        build(:banner, url: "tonystark.com").should_not be_valid
      end

      it "accepts good URLs" do
        build(:banner, url: "http://tonystark.com").should be_valid
      end
    end
  end

  describe "#image_url" do
    it "returns the image's url" do
      banner = described_class.new
      banner.stub(:image) { double(url: :url) }
      banner.image_url.should == :url
    end
  end
end

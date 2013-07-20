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

    describe "positions" do
      it "accepts only the entered positions" do
        Banner::POSITIONS.each do |position|
          build(:banner, position: position).should be_valid
        end
      end

      it "doesn't accept invalid positions" do
        Banner::POSITIONS.each do |position|
          build(:banner, position: "_#{position}").should_not be_valid
        end
      end
    end

    describe "max slots per position" do
      before do
        @company = create(:company)
      end

      it "accepts positions with available slots" do
        create(:banner, company: @company, position: "all_pages_right")
        new_banner = build(:banner,  company: @company.reload, position: "all_pages_right")
        new_banner.should be_valid

        create(:banner, company: @company, position: "all_pages_right")
        new_banner = build(:banner,  company: @company.reload, position: "all_pages_right")
        new_banner.should_not be_valid
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

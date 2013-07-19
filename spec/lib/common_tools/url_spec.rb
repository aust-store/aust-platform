require "common_tools/url"

describe CommonTools::Url do
  describe "#valid?" do
    it "validates a URL" do
      described_class.new("http://www.hey.com").should be_valid
      described_class.new("http://hey.com").should be_valid
      described_class.new("https://www.hey.com").should be_valid

      described_class.new("www.hey.com").should_not be_valid
      described_class.new("hey.com").should_not be_valid
    end
  end
end

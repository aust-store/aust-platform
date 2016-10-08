require "spec_helper"

class DummyElements
  include View::StoreTheme::TemplateElement::Assets
end

describe DummyElements do
  subject { described_class.new }

  describe "active_root_path" do
    it "returns the CDN URL" do
      subject.cdn.should == "https://d17twk90t5po1q.cloudfront.net"
    end
  end
end

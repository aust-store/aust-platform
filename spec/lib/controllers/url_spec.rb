require "spec_helper"

describe Controllers::Url do
  let(:params) { {controller: "haa"} }
  let(:controller) { double(url_for: "http://example.com", params: params) }

  subject { described_class.new(controller) }

  describe "#current_if_same_url" do
    context "matching URL" do
      it "returns current if same url" do
        controller.stub(:root_url) { "http://example.com" }
        subject.current_if_same_url(:root_url).should == "current"
      end

      it "returns current if passed in url matches current one" do
        root_url = "http://example.com"
        subject.current_if_same_url(root_url).should == "current"
      end

      it "returns current if controller name matches passed in url" do
        controller.stub(:root_url) { "another_url" }
        controller.stub(:params) { {controller: "root_url"} }
        subject.current_if_same_url(:root_url).should == "current"
      end
    end

    context "not matching the URL" do
      it "returns nothing if not the same url" do
        controller.stub(:root_url) { "another_url" }
        subject.current_if_same_url(:root_url).should be_nil
      end

      it "returns current if passed in url matches current one" do
        root_url = "crazy string"
        subject.current_if_same_url(root_url).should be_nil
      end
    end
  end
end

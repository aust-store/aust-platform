require "view/store_theme/template_element/html_links"

class DummyElements
  include View::StoreTheme::TemplateElement::HtmlLinks
end

describe DummyElements do
  let(:controller) { double(url_for: "root_path") }

  subject { described_class.new }

  before do
    subject.stub(:controller) { controller }
    subject.stub(:controller_name) { "store_home" }

    controller.stub(:root_url) { "root_path" }
    controller.stub(:something_else_url) { "something_else_path" }
  end

  describe "active_root_path" do
    it "returns 'current' for root_path" do
      subject.current_root_path.should == "current"
    end

    it "returns nothing unless it's root_path" do
      subject.current_something_else_path.should == nil
    end
  end
end

require "spec_helper"

class DummyElements
  include Rails.application.routes.url_helpers

  include View::StoreTheme::TemplateElement::HtmlLinks
end

describe DummyElements do
  subject { described_class.new }

  describe "#products_path" do
    it "returns the products path" do
      subject.products_path.should == "/products"
    end
  end

  describe "active_root_path" do
    let(:params)     { {controller: "store_home"} }
    let(:controller) { double(url_for: "root_path", params: params) }

    before do
      subject.stub(:controller) { controller }
      subject.stub(:controller_name) { "store_home" }

      controller.stub(:root_url) { "root_path" }
      controller.stub(:something_else_url) { "something_else_path" }
    end

    it "returns 'current' for root_path" do
      subject.current_root_path.should == "current"
    end

    it "returns nothing unless it's root_path" do
      subject.current_contact_path.should == nil
    end
  end
end

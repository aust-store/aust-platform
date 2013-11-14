require "spec_helper"

describe View::StoreTheme::MustacheTemplate do
  it_should_behave_like "a mustache template"

  let(:view) { double }
  let(:template_elements) { double }

  subject { described_class.new(view, :content_for_layout) }

  before do
    View::StoreTheme::TemplateElements.stub(:new).with(view) { template_elements }

    template_elements.stub(:custom_method) { :working }
  end

  describe "#yield" do
    it "return the content for the layout" do
      subject.yield.should == "content_for_layout"
    end
  end

  describe "#custom_method" do
    it "forwards the messages to object responsible for the elements" do
      subject.custom_method.should == :working
    end
  end
end

require "view/mustache_content_for_layout"

shared_examples_for "a mustache content for layout" do
  subject { View::MustacheContentForLayout.new(double) }

  it "responds to content_for" do
    subject.should respond_to(:content_for)
  end
end

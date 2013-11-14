require "view/store_theme/mustache_template"

shared_examples_for "a mustache template" do
  subject { View::StoreTheme::MustacheTemplate.new(double) }

  it "responds to respond_to?" do
    subject.should respond_to(:respond_to?)
  end

  it "responds to method_missing" do
    subject.should respond_to(:method_missing)
  end

  it "responds to yield" do
    subject.should respond_to(:yield)
  end

  it "responds to footer" do
    subject.should respond_to(:footer)
  end
end

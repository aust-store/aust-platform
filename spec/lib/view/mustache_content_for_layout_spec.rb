require "spec_helper"

describe View::MustacheContentForLayout do
  it_should_behave_like "a store view"

  let(:params) { {controller: "store_home", action: "index"} }
  let(:controller) { double(params: params) }

  let(:view) do
    double(controller: controller,
           theme_path: "./app/templates/themes",
           theme_name: "minimalism").as_null_object
  end

  subject { described_class.new(view) }

  describe "#content_for" do
    let(:home_template) { File.read("./app/templates/themes/minimalism/home.mustache") }
    let(:rendered_template) { View::StoreTheme::MustacheTemplate.new(view).render(home_template) }

    it "returns the content of a template if it exists" do
      subject.content_for.should == rendered_template
    end

    it "returns nil if a template doesn't exist" do
      view.stub(:theme_name) { "n" }
      subject.content_for.should be_nil
    end
  end
end

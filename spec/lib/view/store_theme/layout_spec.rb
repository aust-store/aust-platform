require "spec_helper"

describe View::StoreTheme::Layout do
  it_should_behave_like "a store view"
  it_should_behave_like "a mustache template"
  it_should_behave_like "a mustache content for layout"

  let(:themes_path) { Rails.root.join(CONFIG["themes"]["paths"]["checked_out"]).to_s }
  let(:theme_path) { "#{themes_path}/minimalism" }

  let(:view) { double(theme_path: theme_path) }
  let(:action_view) { double }

  subject { described_class.new(view, action_view) }

  describe "#layout_to_be_rendered" do
    context "theme with mustache layout" do
      let(:mustache_template) { double }
      let(:layout_template) { File.read("#{theme_path}/layout.mustache") }

      before do
        View::MustacheContentForLayout
          .stub(:new)
          .with(view)
          .and_return(double(content_for: :content))

        View::StoreTheme::MustacheTemplate
          .stub(:new)
          .with(view, :content)
          .and_return(mustache_template)
      end

      it "returns the mustache layout" do
        mustache_template.stub(:render).with(layout_template) { :mustache_layout }
        subject.layout_to_be_rendered.should == { text: "mustache_layout" }
      end
    end

    context "theme without mustache layout" do
      let(:theme_path) { "#{themes_path}/some_inexistent_theme" }

      it "returns the mustache layout" do
        subject.layout_to_be_rendered.should == { template: "layouts/store/non_mustache_layout" }
      end
    end
  end
end

require "spec_helper"

describe Store::MustacheThemesHelper do
  describe ".render_theme_template" do
    let(:view)         { double }
    let(:rails_view)   { double }
    let(:theme_layout) { double }

    it "renders the theme layout" do
      @store_view = view
      View::StoreTheme::Layout.stub(:new).with(view, rails_view) { theme_layout }
      theme_layout.should_receive(:layout_to_be_rendered) { :layout }

      helper.stub(:render).with(:layout) { :rendered }
      helper.render_theme_layout(rails_view).should == :rendered
    end
  end
end

require "view/store_theme"

describe View::StoreTheme do
  let(:theme) { double }

  subject { described_class.new(theme) }

  describe "#has_feature?" do
    it "returns true if the theme has this feature" do
      theme.stub(:vertical_menu) { true }
      subject.has_feature?(:vertical_menu).should be_true
    end

    it "returns false if the theme doesn't have this feature" do
      theme.stub(:vertical_menu) { false }
      subject.has_feature?(:vertical_menu).should be_false
    end

    it "retrrns false if the theme doesn't respond to the feature" do
      subject.has_feature?(:abcdef).should be_false
    end
  end

  describe "#feature_as_class" do
    context "the theme has this feature" do
      it "returns the feature name to be used as a html class" do
        theme.stub(:vertical_menu) { true }
        subject.feature_as_class(:vertical_menu).should == "with_vertical_menu"
      end
    end

    context "the theme doesn't have this feature" do
      it "returns nothing" do
        theme.stub(:vertical_menu) { false }
        subject.feature_as_class(:vertical_menu).should be_nil
      end
    end
  end

  describe "methods that descend from the active record object" do
    before do
      theme.stub(:path) { :path_from_above }
    end

    it "returns path because the theme has this method" do
      subject.path.should == :path_from_above
    end

    it "raises when calling abc because the them doesn't have this method" do
      expect { subject.abc }.to raise_error NoMethodError
    end
  end
end

require 'spec_helper'

describe Theme do
  it_should_behave_like "a company editable theme"

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :path }
    it { should validate_uniqueness_of :path }
  end

  describe "#create_for_company" do
    let(:company_theme) { double }

    it "creates a theme for a company" do
      Store::CompanyEditableTheme.stub(:new).with(:company) { company_theme }
      company_theme.stub(:create) { :new_theme }

      ::Theme.create_for_company(:company).should == :new_theme
    end
  end

  describe ".default_theme_template_path" do
    it "returns a path" do
      checked_out_path = CONFIG["themes"]["paths"]["checked_out"]
      ::Theme.default_theme_template_path
        .should == Rails.root.join(checked_out_path, "minimalism").to_s
    end
  end

  describe "#full_path" do
    let(:theme_path) { Rails.root.join(CONFIG["themes"]["paths"]["checked_out"]) }
    let(:theme_name) { "minimalism" }
    subject { build(:theme, :minimalism) }

    it "finds what's the path of the theme" do
      subject.full_path.should == "#{theme_path.to_s}/#{theme_name}"
    end
  end

  describe "#nature" do
    let(:theme_path) { Rails.root.join(CONFIG["themes"]["paths"]["checked_out"]) }
    let(:test_theme_path) { Rails.root.join(CONFIG["themes"]["paths"]["cloud"]) }
    let(:theme_name) { "minimalism" }
    subject { create(:theme, :minimalism) }

    it "returns checked_out for native themes" do
      subject.nature.should == "checked_out"
    end

    it "returns test for created themes" do
      create_test_theme(subject)
      subject.nature.should == "test"
    end

    it "returns cloud for dynamically created themes" do
      theme_model = subject
      subject = create_cloud_theme(theme_model)
      subject.nature.should == "cloud"
    end
  end

  describe "#editable" do
    context "when a cloud theme" do
      before do
        subject.stub(:nature) { "cloud" }
      end

      it "returns true" do
        subject.should be_editable
      end
    end

    context "when a checked_out theme" do
      before do
        subject.stub(:nature) { "checked_out" }
      end

      it "returns false" do
        subject.should_not be_editable
      end
    end

    context "when a test theme" do
      before do
        subject.stub(:nature) { "test" }
      end

      it "returns true" do
        subject.should be_editable
      end
    end
  end
end

require 'spec_helper'

describe Theme do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :path }
    it { should validate_uniqueness_of :path }
  end

  describe "#create_for_company" do
    let(:company) { create(:barebone_company, name: "Company / \ #2") }
    let(:company2) { create(:barebone_company, name: "Company #3") }

    before do
      company2 and company
    end

    it "creates a theme for a company" do
      new_theme = Theme.create_for_company(company)
      Theme.count.should == 1
      new_theme.name.should == "#{company.name} v1"
      new_theme.path.should == "#{company.id}_company_2_v1"
      new_theme.company.should == company
      new_theme.public.should be_false

      another_new_theme = Theme.create_for_company(company)
      Theme.count.should == 2
      another_new_theme.path.should == "#{company.id}_company_2_v2"

      cloud_path = CONFIG["themes"]["paths"]["cloud"]
      theme1_path = Rails.root.join(cloud_path, "#{company.id}_company_2_v1").to_s
      theme2_path = Rails.root.join(cloud_path, "#{company.id}_company_2_v2").to_s
      exists1 = Dir.exists?(theme1_path)
      exists2 = Dir.exists?(theme2_path)
      exists1.should be_true
      exists2.should be_true
      FileUtils.remove_dir(theme1_path)
      FileUtils.remove_dir(theme2_path)
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

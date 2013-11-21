require 'spec_helper'

describe ThemeFile do
  let(:theme) { create(:theme, :minimalism) }
  let(:filename) { nil }
  let(:test_dir) { "#{Rails.root.join(CONFIG["themes"]["paths"]["test"])}" }
  let(:test_theme_path) { "#{test_dir}/#{theme.path}" }

  subject { described_class.new(theme, filename) }

  describe "#find" do
    let(:test_file) { "layout.mustache"}

    it "returns only one file" do
      subject.find(test_file).to_json.should == file_content(test_file)
    end
  end

  describe "#all" do
    # We copy the main theme to a test folder, so we can change it at will
    before do
      copy_files_to_test_dir
    end

    it "finds what's the path of the theme" do
      subject.all.map(&:to_json).should == [
        file_content("home.mustache"),
        file_content("layout.mustache"),
        file_content("product.mustache"),
        file_content("style.css"),
      ]
    end
  end

  describe "#update_attributes" do
    let(:filename) { "layout.mustache" }

    # We copy the main theme to a test folder, so we can change it at will
    before do
      copy_files_to_test_dir
    end

    describe "body" do
      it "returns the file name" do
        File.read("#{test_theme_path}/#{filename}").should_not == "new body"
        subject.update_attributes(body: "new body")
        File.read("#{test_theme_path}/#{filename}").should == "new body"
        subject.body.should == "new body"
      end
    end
  end

  describe "#id" do
    let(:filename) { "layout.mustache" }

    it "returns the file name" do
      subject.id.should == "layout.mustache"
    end
  end

  describe "#filename" do
    let(:filename) { "layout.mustache" }

    it "returns the file name" do
      subject.filename.should == "layout.mustache"
    end
  end

  describe "#body" do
    let(:filename) { "layout.mustache" }

    it "returns the file name" do
      subject.body.should == File.read("#{theme.full_path}/#{filename}")
    end
  end

  describe "#name" do
    let(:filename) { "layout.mustache" }

    it "returns the file name" do
      i18n = I18n.t("admin.theme_files.#{filename.gsub(/\./, "_")}.name")
      subject.name.should == i18n
    end
  end

  describe "#description" do
    let(:filename) { "layout.mustache" }

    it "returns the file name" do
      i18n = I18n.t("admin.theme_files.#{filename.gsub(/\./, "_")}.description")
      subject.description.should == i18n
    end
  end

  def file_content(filename)
    full_path = "#{theme.full_path}/#{filename}"
    i18n = "admin.theme_files.#{filename.gsub(/\./, "_")}"
    { id: filename,
      filename: filename,
      name: I18n.t("#{i18n}.name"),
      description: I18n.t("#{i18n}.description"),
      theme_id: theme.id,
      body: File.read(full_path) }
  end

  def copy_files_to_test_dir
    FileUtils.rm_rf(test_theme_path)
    FileUtils.mkdir_p("#{test_dir}")
    unless theme.full_path =~ /#{test_dir}/
      FileUtils.cp_r(theme.full_path, test_dir)
    end
  end
end

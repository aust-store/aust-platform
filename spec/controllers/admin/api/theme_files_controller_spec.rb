require 'spec_helper'

describe Admin::Api::ThemeFilesController do
  login_admin

  let(:theme) { FactoryGirl.create(:theme, :minimalism) }

  describe "GET index" do
    context "all theme files" do
      it "returns all files" do
        xhr :get, :index, theme_id: theme.id
        json = ActiveSupport::JSON.decode(response.body)

        json.should == {
          "theme_files" => [
            file_json("home.mustache"),
            file_json("layout.mustache"),
            file_json("product.mustache"),
            file_json("style.css"),
          ]
        }
      end
    end
  end

  describe "PUT update" do
    let(:theme_name) { "test_v1" }
    let(:test_dir) { "#{Rails.root.join(CONFIG["themes"]["paths"]["test"])}" }
    let(:test_file) { "layout.mustache" }
    let(:full_file_path) { [test_dir, theme_name, test_file].join("/") }
    let(:theme) { create(:theme, :minimalism, path: theme_name) }

    before do
      system "mkdir -p #{test_dir}/#{theme_name}"
      system "touch #{full_file_path}"
    end

    after do
      FileUtils.rm_rf(test_dir)
    end

    it "updates a theme file" do
      File.read(full_file_path).should == ""
      put :update, id: test_file, theme_file: {
        "id" => test_file,
        "filename" => test_file,
        "body" => "new body",
        "theme_id" => theme.id,
      }

      json = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "theme_file" => file_json(test_file)
      }
      File.read(full_file_path).should == "new body"
    end
  end

  def file_json(filename)
    body = File.read("#{theme.full_path}/#{filename}")
    i18n = "admin.theme_files.#{filename.gsub(/\./, "_")}"

    { "id" => filename,
      "name" => I18n.t("#{i18n}.name"),
      "description" => I18n.t("#{i18n}.description"),
      "filename" => filename,
      "body" => body,
      "preview_url" => admin_theme_preview_url(theme, filename: filename) }
  end
end

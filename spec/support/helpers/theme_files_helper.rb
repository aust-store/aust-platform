module Helpers
  module ThemeFiles
    def create_test_theme(theme_model)
      create_new_theme_files(theme_model, :test)
    end

    def create_cloud_theme(theme_model)
      create_new_theme_files(theme_model, :cloud)
    end

    def create_new_theme_files(theme_model, type = :test)
      dir_to_be_used = self.send("#{type}_theme_dir".to_sym)

      # Generates a name for the directory such as `minimalism_3417851325`
      theme_name = "#{theme_model.path}_#{Time.now.to_f.to_s.delete(".")}"
      # Changes the path to something like `minimalism_3417851325`
      theme_model.path = theme_name

      new_theme_full_path = "#{dir_to_be_used}/#{theme_name}"
      FileUtils.mkdir_p(dir_to_be_used)
      FileUtils.cp_r(::Theme.default_theme_template_path, new_theme_full_path)
      theme_model
    end

    def test_theme_dir
      "#{Rails.root.join(CONFIG["themes"]["paths"]["test"])}"
    end

    def cloud_theme_dir
      "#{Rails.root.join(CONFIG["themes"]["paths"]["cloud"])}"
    end
  end
end

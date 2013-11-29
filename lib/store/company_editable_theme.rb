module Store
  class CompanyEditableTheme
    def initialize(company)
      @company = company
    end

    def create
      path = "#{company.id}_#{company.name.underscore}_v"
      path = path.gsub(/\s/, "_")
      # converts something like `3 Company #2` to `3_company_2`
      path = path.gsub(/[^a-zA-Z0-9_]/, "").strip
      path = path.gsub(/__/, "_").gsub(/__/, "_")

      # Finds out what's the latest version and increments the number
      unique_path = false
      version = 1
      while !unique_path && version < 100
        matching_theme = Theme.where(path: "#{path}#{version}").first
        if matching_theme.present?
          version += 1
        else
          unique_path = true
          path = "#{path}#{version}"
        end
      end

      new_theme = ::Theme.new(company_id: company.id,
                              public:     false,
                              name:       "#{company.name} v#{version}",
                              path:       "#{path}")

      if new_theme.valid?
        new_theme_full_path = "#{new_theme.path_for_new_theme}/#{path}"
        FileUtils.cp_r(::Theme.default_theme_template_path, new_theme_full_path)
        # these new themes won't have a proper preview image
        FileUtils.rm("#{new_theme_full_path}/preview.png", force: true)
        FileUtils.rm("#{new_theme_full_path}/preview.jpg", force: true)
      end
      new_theme.save
      new_theme
    end

    private

    attr_reader :company
  end
end

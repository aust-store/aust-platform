class Theme < ActiveRecord::Base
  DEFAULT_THEME_PATH = "minimalism"

  attr_accessible :description, :name, :path, :public, :company_id,
                  :vertical_taxonomy_menu

  belongs_to :company

  validates :name, :path, presence: true
  validates :path, uniqueness: true

  scope :accessible_for_company, ->(company) { where("public = ? OR company_id = ?", true, company.id) }
  scope :default_theme, ->{ where(name: "Overblue") }

  def company_name
    company and company.name
  end

  def self.create_for_company(company)
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

    new_theme = self.new(company_id: company.id,
                         public:     false,
                         name:       "#{company.name} v#{version}",
                         path:       "#{path}")

    if new_theme.valid?
      new_theme_full_path = "#{new_theme.cloud_themes_path}/#{path}"
      FileUtils.cp_r(new_theme.default_theme_template_path, new_theme_full_path)
      FileUtils.rm("#{new_theme_full_path}/preview.png", force: true)
      FileUtils.rm("#{new_theme_full_path}/preview.jpg", force: true)
    end
    new_theme.save
    new_theme
  end

  def nature
    CONFIG["themes"]["paths"].keys.find do |key|
      themes_dir = CONFIG["themes"]["paths"][key]
      hypothesis = Rails.root.join(themes_dir, self.path).to_s
      Dir.exists?(hypothesis)
    end
  end

  def default_theme_template_path
    Rails.root.join(CONFIG["themes"]["paths"]["checked_out"], DEFAULT_THEME_PATH).to_s
  end

  def full_path
    CONFIG["themes"]["paths"].keys.each do |key|
      themes_dir = CONFIG["themes"]["paths"][key]
      hypothesis = Rails.root.join(themes_dir, self.path).to_s
      return hypothesis if Dir.exists?(hypothesis)
    end
    nil
  end

  def cloud_themes_path
    Rails.root.join(CONFIG["themes"]["paths"]["cloud"]).to_s
  end

  def files
    ThemeFile.new(self)
  end
end

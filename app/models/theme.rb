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
      new_theme_full_path = "#{new_theme.path_for_new_theme}/#{path}"
      FileUtils.cp_r(::Theme.default_theme_template_path, new_theme_full_path)
      FileUtils.rm("#{new_theme_full_path}/preview.png", force: true)
      FileUtils.rm("#{new_theme_full_path}/preview.jpg", force: true)
    end
    new_theme.save
    new_theme
  end

  # Nature is a synonynm to type here. It'll return a string with the type of
  # theme, which could be:
  #
  #   - checked_out: created during development and present in git
  #   - cloud: created by the admins and not present on git
  #   - private: those that are in the /private directory
  def nature
    CONFIG["themes"]["paths"].keys.find do |key|
      themes_dir = CONFIG["themes"]["paths"][key]
      hypothesis = Rails.root.join(themes_dir, self.path).to_s
      Dir.exists?(hypothesis)
    end
  end

  # Used for cloning during cloud themes creation.
  def self.default_theme_template_path
    Rails.root.join(CONFIG["themes"]["paths"]["checked_out"], DEFAULT_THEME_PATH).to_s
  end

  # Returns something like /var/project/store/public/themes/cloud/minimalism
  def full_path
    theme_path = [CONFIG["themes"]["paths"][nature], self.path].join("/")
    Rails.root.join(theme_path).to_s
  end

  def files
    ThemeFile.new(self)
  end

  def path_for_new_theme
    Rails.root.join(CONFIG["themes"]["paths"]["cloud"]).to_s
  end

  def editable?
     ["cloud", "test"].include?(self.nature.to_s)
  end
end

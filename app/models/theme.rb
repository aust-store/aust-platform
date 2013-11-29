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
    Store::CompanyEditableTheme.new(company).create
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

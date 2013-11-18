class Theme < ActiveRecord::Base
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

    self.create(company_id: company.id,
                public:     false,
                name:       "#{company.name} v#{version}",
                path:       "#{path}")
  end
end

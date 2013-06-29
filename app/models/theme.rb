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
end

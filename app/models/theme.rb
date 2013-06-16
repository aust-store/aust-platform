class Theme < ActiveRecord::Base
  attr_accessible :description, :name, :path, :public

  validates :name, :path, presence: true
  validates :path, uniqueness: true

  scope :public, ->{ where(public: true) }
  scope :default_theme, ->{ where(name: "Overblue") }
end

class Theme < ActiveRecord::Base
  attr_accessible :description, :name, :path, :private

  validates :name, :path, presence: true
  validates :path, uniqueness: true
end

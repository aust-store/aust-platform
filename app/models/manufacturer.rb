class Manufacturer < ActiveRecord::Base
  extend ModelExtensions::FullTextSearch

  attr_accessible :admin_user_id, :company_id, :name

  belongs_to :company
  belongs_to :admin_user

  validates :name, presence: true

  def self.search_for(query)
    search do
      fields :name
      keywords query
    end
  end
end

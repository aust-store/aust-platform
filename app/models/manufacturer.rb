class Manufacturer < ActiveRecord::Base
  extend ModelExtensions::FullTextSearch

  attr_accessible :company_id, :name

  belongs_to :company

  def self.search_for(query)
    search do
      fields :name
      keywords query
    end
  end
end

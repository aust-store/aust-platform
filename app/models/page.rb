class Page < ActiveRecord::Base
  attr_accessible :body, :company_id, :title

  belongs_to :company

  validates :company, :title, :body, presence: true
end

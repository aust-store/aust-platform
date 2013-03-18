class Page < ActiveRecord::Base
  attr_accessible :body, :company_id, :title

  belongs_to :company

  validates :company_id, presence: true
  validates :title, presence: true
end

class Customer < ActiveRecord::Base
  belongs_to :company

  scope :within_company, lambda { |company| where(company_id: company.id) }

  validates :first_name, :last_name, :description, presence: true

  def name
    "#{first_name} #{last_name}"
  end

end

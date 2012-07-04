class Customer < ActiveRecord::Base
  belongs_to :company

  scope :within_company, lambda { |company| where(company_id: company.id) }

  validates :first_name, :last_name, :description, presence: true

  # TODO - move these methods to a module and load them as mixins
  def name
    "#{first_name} #{last_name}"
  end
end

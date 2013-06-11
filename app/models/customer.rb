class Customer < ActiveRecord::Base

  belongs_to :company
  validates :first_name, :last_name, :description, :company, presence: true

  def name
    "#{first_name} #{last_name}"
  end
end

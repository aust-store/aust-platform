class Good < ActiveRecord::Base
  
  belongs_to :inventory, class_name: "InventoryPersistence"
  belongs_to :user, class_name: "AdminUser", foreign_key: 'admin_user_id'
  belongs_to :company
  has_many :balances, class_name: "Good::Balance"
  has_one :last_balance, class_name: "Good::Balance", order: "updated_at desc", readonly: true

  accepts_nested_attributes_for :balances

  validates :name, :admin_user_id, :company_id, presence: true

  scope :within_company, lambda { |company| where(company_id: company.id) }

  before_create :associate_with_inventory

  searchable do
    text :name, as: :name_textp
    text :description
    integer :company_id
  end

  def associate_with_inventory
    self.inventory = self.company.inventory
  end
end

class Good < ActiveRecord::Base

  include ::Store::ModelsExtensions::Good

  belongs_to :inventory
  belongs_to :user, class_name: "AdminUser", foreign_key: 'admin_user_id'
  belongs_to :company
  has_many :balances, class_name: "InventoryEntry"
  has_one :last_balance, class_name: "InventoryEntry", order: "updated_at desc", readonly: true
  has_many :images, class_name: "GoodImage", order: "id asc"

  accepts_nested_attributes_for :balances
  accepts_nested_attributes_for :images

  validates :name, :admin_user_id, :company_id, presence: true

  scope :within_company, lambda { |company| where(company_id: company.id) }

  before_create :associate_with_inventory

  def associate_with_inventory
    self.inventory = self.company.inventory
  end

  def self.search_for query
    Store::ItemsSearch.new(self, query).search
  end
end

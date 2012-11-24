class InventoryItem < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :user, class_name: "AdminUser", foreign_key: 'admin_user_id'
  belongs_to :company
  has_many :balances, class_name: "InventoryEntry", uniq: true,
    order: "inventory_entries.created_at asc, inventory_entries.id asc"
  has_one :last_balance, class_name: "InventoryEntry", order: "updated_at desc", readonly: true
  has_many :images, class_name: "InventoryItemImage"


  accepts_nested_attributes_for :balances
  accepts_nested_attributes_for :images

  validates :name, :admin_user_id, :company_id, presence: true

  scope :within_company, lambda { |company| where(company_id: company.id) }
  scope :with_entries_for_sale, lambda {
    includes(:images).includes(:balances)
    .where("inventory_item_images.cover = ?", true)
    .where("inventory_entries.quantity > 0")
    .where("inventory_entries.on_sale = ?", true)
    .order("inventory_entries.created_at asc, inventory_entries.id asc")
  }

  scope :detailed_item_for_sale, lambda {
    includes(:images).includes(:balances)
    .order("inventory_item_images.cover desc")
    .where("inventory_entries.on_sale = ?", true)
    .order("inventory_entries.created_at asc, inventory_entries.id asc")
  }

  before_create :associate_with_inventory

  def entry_for_sale
    self.balances.on_sale.first
  end

  def all_entries_available_for_sale
    self.balances.all_entries_available_for_sale.all
  end

  def associate_with_inventory
    self.inventory = self.company.inventory
  end

  def total_quantity
    balances.sum(:quantity)
  end

  def price
    Store::ItemPrice.new(self).price
  end

  def self.search_for(query)
    Store::ItemsSearch.new(self, query).search.includes(:balances)
  end
end

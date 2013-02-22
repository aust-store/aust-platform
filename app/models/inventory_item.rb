class InventoryItem < ActiveRecord::Base
  extend ModelExtensions::FullTextSearch

  belongs_to :inventory
  belongs_to :manufacturer
  belongs_to :user, class_name: "AdminUser", foreign_key: 'admin_user_id'
  belongs_to :company
  belongs_to :taxonomy

  has_many :prices,
    class_name: "InventoryItemPrice",
    order: "inventory_item_prices.id asc"

  has_many :entries, class_name: "InventoryEntry"

  # TODO remove balances
  has_many :balances, class_name: "InventoryEntry", order: "inventory_entries.created_at asc, inventory_entries.id asc"
  has_many :images, class_name: "InventoryItemImage"
  has_one :last_balance, class_name: "InventoryEntry", order: "updated_at desc", readonly: true
  has_one :shipping_box
  has_one :properties, class_name: "InventoryItemProperty"

  accepts_nested_attributes_for :shipping_box
  accepts_nested_attributes_for :balances
  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :entries
  accepts_nested_attributes_for :prices
  accepts_nested_attributes_for :taxonomy
  accepts_nested_attributes_for :manufacturer

  before_validation :remove_empty_shipping_box

  validates :name, :admin_user_id, :company_id, presence: true

  FIRST_ENTRY_FLAG = "min(id)"
  LAST_ENTRY_FLAG  = "max(id)"

  scope :within_company, lambda { |company| where(company_id: company.id) }
  scope :with_entry_for_sale, lambda {
    joins(:prices).includes(:images).includes(:balances)
    .where("inventory_entries.id = (
      SELECT #{FIRST_ENTRY_FLAG}
      FROM inventory_entries
      WHERE inventory_entries.inventory_item_id=inventory_items.id
      AND inventory_entries.quantity > 0
      LIMIT 1)")
    .where("inventory_item_images.cover = ?", true)
  }

  scope :detailed_item_for_sale, lambda {
    includes(:images).includes(:balances)
    .order("inventory_item_images.cover desc")
    .order("inventory_entries.created_at asc, inventory_entries.id asc")
  }

  before_create :associate_with_inventory

  def entry_for_sale
    self.balances.on_sale.first
  end

  def self.items_on_sale
    with_entry_for_sale.limit(12).order("inventory_items.created_at desc")
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
    search do
      fields :name, :description
      keywords query
    end.includes(:balances)
  end

  def remove_empty_shipping_box
    if shipping_box.present?
      self.shipping_box.destroy unless self.shipping_box.dependent_fields_present?
    end
    true
  end
end

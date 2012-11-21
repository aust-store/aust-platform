class Company < ActiveRecord::Base
  has_many :admin_users
  has_many :customers
  has_many :items, class_name: "InventoryItem"
  has_many :carts
  has_many :inventory_entries, foreign_key: "store_id"

  has_one :inventory

  accepts_nested_attributes_for :admin_users

  before_create :create_inventory

  def distinct_items
    self.items.with_entries_for_sale.all
  end

  def detailed_item(id)
    self.items.detailed_item_for_sale.find(id)
  end

  def create_inventory
    self.build_inventory
  end

  def to_param
    handle
  end
end

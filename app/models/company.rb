class Company < ActiveRecord::Base
  has_many :admin_users
  has_many :customers
  has_many :items, class_name: "InventoryItem"
  has_many :carts
  has_many :inventory_entries, foreign_key: "store_id"

  has_one :inventory
  has_one :settings, class_name: "CompanySetting"

  accepts_nested_attributes_for :admin_users

  before_create :create_inventory

  def items_on_sale_on_main_page
    self.items.items_on_sale
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

  def zipcode
    settings.zipcode
  end
end

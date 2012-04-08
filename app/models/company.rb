class Company < ActiveRecord::Base
  has_many :admin_users
  has_many :customers

  has_one :inventory, class_name: "InventoryPersistence"

  accepts_nested_attributes_for :admin_users

  before_create :create_inventory

  def create_inventory
    self.build_inventory
  end
end

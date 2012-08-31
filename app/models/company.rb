class Company < ActiveRecord::Base
  has_many :admin_users
  has_many :customers
  has_many :items, class_name: "Good"
  has_many :inventory_entries, foreign_key: "store_id"

  has_one :inventory

  accepts_nested_attributes_for :admin_users

  before_create :create_inventory


  def distinct_inventory_entries
    # TODO fix which items should appear
    self.inventory_entries.all
  end

  def create_inventory
    self.build_inventory
  end

  def list_goods
    Good.within_company(self).all
  end

  def to_param
    handle
  end
end

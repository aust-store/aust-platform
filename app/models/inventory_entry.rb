class InventoryEntry < ActiveRecord::Base
  belongs_to :store, foreign_key: "store_id", class_name: "Company"
  belongs_to :inventory_item
  belongs_to :admin_user

  attr_accessible :inventory_item_id, :description, :quantity, :cost_per_unit, :inventory_item,
                  :admin_user_id, :balance_type, :moving_average_cost,
                  :total_quantity, :total_cost, :store_id, :price, :on_sale

  accepts_nested_attributes_for :inventory_item

  validates :price, presence: true
  validates :cost_per_unit, presence: true
  validates :quantity, presence: true,
    numericality: { greater_than: 0 }, on: :create

  # TODO hum? can we remove this callback later?
  before_save :define_new_balance_values

  scope :on_sale, lambda {
    where("inventory_entries.on_sale = ?", true)
    .all_entries_available_for_sale
  }

  scope :all_entries_available_for_sale, lambda {
    where("inventory_entries.quantity > 0")
    .order("inventory_entries.created_at asc, inventory_entries.id asc")
  }

  class OutOfStock < StandardError; end

  def define_new_balance_values
    past_balances = InventoryEntry.where(inventory_item_id: inventory_item_id)
                                  .where("quantity > 0")
                                  .all
    balance = Store::DomainObject::Balance.new([self] + past_balances)

    self.total_quantity      = balance.total_quantity
    self.total_cost          = balance.total_cost
    self.moving_average_cost = balance.moving_average_cost
  end
end

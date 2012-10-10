class InventoryEntry < ActiveRecord::Base
  belongs_to :store, foreign_key: "store_id", class_name: "Company"
  belongs_to :good
  belongs_to :admin_user

  attr_accessible :good_id, :description, :quantity, :cost_per_unit, :good,
                  :admin_user_id, :balance_type, :moving_average_cost,
                  :total_quantity, :total_cost, :store_id, :price

  accepts_nested_attributes_for :good

  validates :price, presence: true
  validates :cost_per_unit, presence: true
  validates :quantity, presence: true

  # TODO hum? can we remove this callback later?
  before_save :define_new_balance_values

  class OutOfStock < StandardError; end

  def define_new_balance_values
    past_balances = InventoryEntry.where(good_id: good_id).where("quantity > 0").all
    balance = Store::DomainObject::Balance.new([self] + past_balances)

    self.total_quantity      = balance.total_quantity
    self.total_cost          = balance.total_cost
    self.moving_average_cost = balance.moving_average_cost
  end
end

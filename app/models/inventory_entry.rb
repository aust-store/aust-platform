class InventoryEntry < ActiveRecord::Base
  belongs_to :store, foreign_key: "store_id", class_name: "Company"
  belongs_to :inventory_item
  belongs_to :admin_user

  attr_accessible :inventory_item_id, :inventory_item,
                  :admin_user_id, :store_id,
                  :description, :quantity, :cost_per_unit, :on_sale

  accepts_nested_attributes_for :inventory_item

  validates :cost_per_unit, presence: true
  validates :quantity, presence: true,
    numericality: { greater_than: 0 }, on: :create

  before_create :define_new_balance_values
  before_create :define_company_on_create

  scope :on_sale, lambda {
    where("inventory_entries.on_sale = ?", true).all_entries_available_for_sale
  }

  scope :all_entries_available_for_sale, lambda {
    where("inventory_entries.quantity > 0")
    .order("inventory_entries.created_at asc, inventory_entries.id asc")
  }

  class OutOfStock < StandardError; end

  def define_new_balance_values
    Context::ItemMovingAverageCostDefinition.new(self).define
  end

  private

  def define_company_on_create
    self.store_id = self.inventory_item.company_id
  end
end

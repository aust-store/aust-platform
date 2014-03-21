class InventoryEntry < ActiveRecord::Base
  class NegativeQuantity < StandardError; end

  belongs_to :store, foreign_key: "store_id", class_name: "Company"
  belongs_to :inventory_item
  belongs_to :admin_user

  attr_accessible :inventory_item_id, :inventory_item,
                  :admin_user_id, :store_id,
                  :description, :quantity, :cost_per_unit, :on_sale,
                  :website_sale, :point_of_sale

  accepts_nested_attributes_for :inventory_item

  validates :cost_per_unit, presence: true
  validates :quantity, presence: true,
    numericality: { greater_than: 0 }, on: :create

  before_validation :observe_negative_quantity, on: :update
  before_create :define_new_balance_values
  before_create :define_company_on_create

  scope :on_sale, lambda {
    where("inventory_entries.on_sale = ?", true)
    .with_quantity
  }

  scope :for_website, lambda { where("inventory_entries.website_sale = ?", true) }
  scope :for_point_of_sale, lambda { where("inventory_entries.point_of_sale = ?", true) }
  scope :with_quantity, lambda { where("inventory_entries.quantity > 0") }
  scope :default_order, lambda {
    order("inventory_entries.created_at asc, inventory_entries.id asc")
  }
  scope :all_entries_available_for_sale, lambda { on_sale.with_quantity.default_order }

  class OutOfStock < StandardError; end

  def define_new_balance_values
    Context::ItemMovingAverageCostDefinition.new(self).define
  end

  private

  def define_company_on_create
    self.store_id = self.inventory_item.company_id
  end

  def observe_negative_quantity
    raise InventoryEntry::NegativeQuantity if self.quantity < 0
  end
end

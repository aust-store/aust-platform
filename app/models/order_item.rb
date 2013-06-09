class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :cart
  has_many :children, class_name: "OrderItem",
    foreign_key: :parent_id, dependent: :destroy
  belongs_to :inventory_item
  belongs_to :inventory_entry

  VALID_STATUSES = [:pending, :shipped, :cancelled]

  validates :status, inclusion: { in: VALID_STATUSES.map(&:to_s) }

  before_validation :set_status_as_pending
  before_validation :set_quantity_to_one

  scope :parent_items, ->{ where(parent_id: nil) }

  scope :same_line_items, ->(inventory_entry) {
    where("inventory_entry_id = ?", inventory_entry.id)
      .where("price = ?", inventory_entry.inventory_item.price)
      .parent_items
  }

  # callbacks
  def set_status_as_pending
    self.status = "pending" unless self.status.present?
  end

  def set_quantity_to_one
    self.quantity = 1 if self.quantity.zero?
    true
  end

  def update_quantity(new_quantity)
    ::Persistence::OrderItemQuantity.new(self).change(new_quantity)
  end

  def shipping_box
    inventory_item.shipping_box
  end

  def name
    inventory_item.name
  end

  def description
    inventory_item.description
  end

  def quantity
    children.count + super.to_i
  end

  def self.statuses
    all.map(&:status).map(&:to_sym)
  end

  def self.has_shipped?
    statuses.include?(:shipped)
  end

  def self.has_pending?
    statuses.include?(:pending)
  end

  def self.some_shipped_some_pending?
    has_shipped? && has_pending?
  end

  def self.all_pending_shipment?
    !has_shipped? && has_pending?
  end

  def self.all_shipped?
    has_shipped? && !has_pending?
  end

  def self.all_cancelled?
    statuses.all? { |status| status == :cancelled }
  end

  def inherited_attributes
    parent_attributes = self.attributes
    parent_attributes.delete("created_at")
    parent_attributes.delete("updated_at")
    parent_attributes.delete("status")
    parent_attributes
  end
end

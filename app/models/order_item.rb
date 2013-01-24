class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :cart
  belongs_to :inventory_item
  belongs_to :inventory_entry
  has_one :shipping_box

  VALID_STATUSES = [:pending, :shipped, :cancelled]

  validates :status, inclusion: { in: VALID_STATUSES.map(&:to_s) }

  before_validation :set_status_as_pending

  def remaining_entries_in_stock
    inventory_entry.quantity
  end

  def update_quantity(quantity)
    quantity = remaining_entries_in_stock if quantity > remaining_entries_in_stock
    quantity = 0 if quantity < 0
    update_attributes(quantity: quantity)
  end

  def name
    inventory_item.name
  end

  def description
    inventory_item.description
  end

  def quantity
    super.to_i
  end

  def set_status_as_pending
    self.status = "pending" unless self.status.present?
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
end

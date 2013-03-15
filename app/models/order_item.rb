class OrderItem < ActiveRecord::Base
  belongs_to :order
  has_many   :children, class_name: "OrderItem",
    foreign_key: :related_id, dependent: :destroy
  belongs_to :cart
  belongs_to :inventory_item
  belongs_to :inventory_entry

  VALID_STATUSES = [:pending, :shipped, :cancelled]

  validates :status, inclusion: { in: VALID_STATUSES.map(&:to_s) }

  before_validation :set_status_as_pending
  before_validation :set_quantity_to_one

  # callbacks
  def set_status_as_pending
    self.status = "pending" unless self.status.present?
  end

  def set_quantity_to_one
    self.quantity = 1 if self.quantity.zero?
    true
  end

  def remaining_entries_in_stock
    inventory_entry.quantity
  end

  def update_quantity(quantity)
    quantity = 0 if quantity < 0
    quantity = remaining_entries_in_stock if quantity > remaining_entries_in_stock
    quantity = quantity.to_s.to_i

    if quantity != self.quantity
      if quantity > 0
        if quantity > quantity_with_children
          create_order_items_children(quantity)
        elsif quantity < quantity_with_children
          (quantity_with_children - quantity).times do
            children.last.destroy
          end
        end
      else
        delete_all_children
        self.quantity = 0
      end
    end
  end

  def create_order_items_children(quantity)
    parent_attributes = self.attributes
    parent_attributes.delete("updated_at")
    (quantity - quantity_with_children).times do
      children << children.build(parent_attributes)
    end
  end

  def delete_all_children
    children.destroy_all
  end

  def name
    inventory_item.name
  end

  def description
    inventory_item.description
  end

  def quantity_with_children
    children.count + 1
  end

  def quantity
    if has_children?
      quantity_with_children
    else
      super.to_i
    end
  end

  def self.all_parent_items
    self.where(related_id: nil).all
  end

  def has_children?
    children.count > 0
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

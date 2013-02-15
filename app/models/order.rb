class Order < ActiveRecord::Base
  attr_accessible :cart_id, :store_id, :user_id, :items_attributes, :items,
    :environment,
    :user, :store, :shipping_address, :shipping_details

  belongs_to :user
  belongs_to :store, class_name: "Company"
  has_many :items, class_name: "OrderItem"
  has_many :payment_statuses, order: "id asc"
  has_one :shipping_details, class_name: "OrderShipping"
  has_one :shipping_address, as: :addressable, class_name: "Address"

  VALID_ENVIRONMENTS = [:website, :offline]

  validates :environment,
    inclusion: { in: VALID_ENVIRONMENTS + VALID_ENVIRONMENTS.map(&:to_s) },
    allow_blank: true

  accepts_nested_attributes_for :items

  scope :created_on_the_website, where(environment: "website")

  def self.create_offline(params)
    create(params.merge(environment: :offline))
  end

  def current_payment_status
    payment_statuses.current_status
  end

  def total
    Store::Order::PriceCalculation.calculate(items)
  end

  def items_quantity
    items.map(&:quantity).reduce(:+)
  end

  def summary
    if paid?
      if    items.some_shipped_some_pending? then :paid_some_shipped_some_pending
      elsif items.all_pending_shipment?      then :paid_pending_all_shipments
      elsif items.all_shipped?               then :paid_and_shipped
      elsif items.all_cancelled?             then :paid_but_shipment_cancelled
      end
    elsif payment_statuses.cancelled?
      :cancelled
    else
      :pending_payment
    end
  end

  def paid?
    @paid = payment_statuses.paid?
  end

  def number
    self.id
  end
end

class Cart < ActiveRecord::Base
  include Models::Extensions::UUID

  uuid field: "uuid"

  belongs_to :customer, class_name: "Person"
  belongs_to :company
  has_many :items, class_name: "OrderItem"
  has_one :shipping, class_name: "OrderShipping"
  has_one :shipping_address, as: :addressable, class_name: "Address"

  accepts_nested_attributes_for :shipping_address
  accepts_nested_attributes_for :items

  validates :environment,
    inclusion: { in: Order::VALID_ENVIRONMENTS + Order::VALID_ENVIRONMENTS.map(&:to_s) },
    allow_blank: true

  scope :point_of_sale, ->{ where(environment: "offline") }

  def self.create_offline(params = {})
    create(params.merge(environment: :offline))
  end

  def total
    Store::Order::PriceCalculation.new(self, items).total
  end

  def total_for_installments
    Store::Order::PriceCalculation.new(self, items).total("installments")
  end

  def current_inventory_entry(id)
    company.inventory_entries.find(id)
  end

  def add_item(inventory_entry_id, quantity = nil)
    entry = current_inventory_entry(inventory_entry_id)
    raise InventoryEntry::OutOfStock unless entry.quantity > 0

    existing_item = item_already_in_cart(entry)

    if existing_item
      increase_item_quantity(existing_item, quantity)
    else
      create_item_into_cart(entry)
    end
  end

  def update_shipping(shipping)
    self.shipping.destroy if self.shipping
    self.shipping = self.build_shipping.create_for_cart(shipping)
  end

  def set_customer(customer)
    self.update_attributes(customer: customer)
  end

  def preliminar_shipping_address

  end

  def zipcode_mismatch?
    zipcode = if shipping_address.nil?
                customer.default_address.zipcode
              else
                shipping_address.zipcode
              end
    shipping.nil? || shipping.zipcode != zipcode
  end

  def reset_shipping
    shipping.destroy if shipping
  end

  def self.find_or_create_cart(cart)
    cart.current_company.carts.find(cart.id)
  rescue ActiveRecord::RecordNotFound
    cart.current_company.carts.create(environment: :website)
  end

  def convert_into_order
    Store::Order::CreationFromCart.new(self).convert_cart_into_order
  end

  def items_shipping_boxes
    shipping_boxes = []
    items.each do |item|
      item.quantity.to_i.times do |t|
        shipping_boxes << item.shipping_box
      end
    end
    shipping_boxes
  end

  private

  def create_item_into_cart(entry)
    item = OrderItem.new(
      price: entry.inventory_item.price,
      price_for_installments: entry.inventory_item.price_for_installments,
      quantity: 1,
      inventory_entry: entry,
      inventory_item: entry.inventory_item
    )

    items << item
    save
  end

  def increase_item_quantity(item, quantity_to_sum)
    quantity = item.quantity + quantity_to_sum
    item.update_quantity(quantity) if quantity.present?
  end

  def item_already_in_cart(inventory_entry)
    items.same_line_items(inventory_entry).first
  end
end

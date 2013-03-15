class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_many :items, class_name: "OrderItem"
  has_one :shipping, class_name: "OrderShipping"
  has_one :shipping_address, as: :addressable, class_name: "Address"

  accepts_nested_attributes_for :shipping_address
  accepts_nested_attributes_for :items

  validates :environment,
    inclusion: { in: Order::VALID_ENVIRONMENTS + Order::VALID_ENVIRONMENTS.map(&:to_s) },
    allow_blank: true

  def self.create_offline(params = {})
    create(params.merge(environment: :offline))
  end

  def all_items
    self.items.all_parent_items
  end

  def total
    Store::Order::PriceCalculation.calculate(all_items)
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

  def item_already_in_cart(inventory_entry)
    products = items.where("price = ?", inventory_entry.inventory_item.price)
    product  = products.all_parent_items.first
  end

  def create_item_into_cart(entry)
    item = OrderItem.new(
      price: entry.inventory_item.price,
      quantity: 1,
      inventory_entry: entry,
      inventory_item: entry.inventory_item
    )

    items << item
    save
  end

  def increase_item_quantity(item, quantity_to_sum)
    quantity = item.quantity + quantity_to_sum
    update_item_quantity(item, quantity)
  end

  def update_item_quantity(item, quantity)
    item.update_quantity(quantity) if quantity.present?
  end

  def update_quantities_in_batch(quantities)
    items.each do |item|
      if quantities.has_key?(item.id.to_s)
        item.update_quantity(quantities[item.id.to_s].to_i)
      end
    end
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
    serialized_fields = {
      cart_id:          self.id,
      environment:      self.environment,
      user:             self.user,
      store:            self.company,
      shipping_address: self.shipping_address,
      shipping_details: self.shipping
    }

    order = Order.create(serialized_fields)
    items.each { |item| order.items << item }
    order.save
    order
  end
end

class InventoryItem < ActiveRecord::Base
  extend Models::Extensions::FullTextSearch
  include Models::Extensions::UUID
  uuid field: "uuid"

  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_taggable
  acts_as_ordered_taggable

  belongs_to :inventory
  belongs_to :manufacturer
  belongs_to :user, class_name: "AdminUser", foreign_key: 'admin_user_id'
  belongs_to :company
  belongs_to :taxonomy
  belongs_to :supplier, class_name: "Person"

  has_many :prices,
    ->{ order("inventory_item_prices.id asc").references(:inventory_item_prices) },
    class_name: "InventoryItemPrice",
    dependent: :destroy

  has_many :entries, class_name: "InventoryEntry", dependent: :destroy
  has_many :order_items

  # TODO remove balances
  has_many :balances,
    ->{ order("inventory_entries.created_at asc, inventory_entries.id asc").references(:inventory_entries) },
    class_name: "InventoryEntry"
  has_many :images, class_name: "InventoryItemImage", dependent: :destroy
  has_one :shipping_box, dependent: :destroy
  # TODO - remove
  has_one :properties, class_name: "InventoryItemProperty"

  before_validation :remove_empty_shipping_box
  before_create :associate_with_inventory

  validates :name, :admin_user_id, :company_id, presence: true
  validates :taxonomy_id, presence: true

  accepts_nested_attributes_for :shipping_box
  accepts_nested_attributes_for :balances
  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :entries
  accepts_nested_attributes_for :prices
  accepts_nested_attributes_for :taxonomy
  accepts_nested_attributes_for :manufacturer

  FIRST_ENTRY_FLAG = "min(inventory_entries.id)"
  LAST_ENTRY_FLAG  = "max(inventory_entries.id)"

  scope :within_company, lambda { |company| where(company_id: company.id) }
  # FIXME two queries are being made whenever you want the entries
  scope :with_entry_for_sale, ->{
    includes(:shipping_box) # shipping box is not needed
      .joins(:images)
      .joins(:prices)
      .includes(:balances)
      .where("inventory_entries.id IN (
        SELECT #{FIRST_ENTRY_FLAG}
        FROM inventory_entries
        WHERE inventory_entries.inventory_item_id=inventory_items.id
        AND inventory_entries.quantity > 0
        AND inventory_entries.on_sale = ?
        GROUP BY inventory_entries.inventory_item_id)", true)
      .where("inventory_entries.on_sale = ?", true)
      .where("inventory_item_images.cover = ?", true)
      .references(:inventory_entries)
      .references(:inventory_item_images)
  }

  scope :with_point_of_sale, -> {
    includes(:balances)
    .where("inventory_entries.point_of_sale = ?", true)
    .references(:inventory_entries)
  }

  scope :with_website_sale, -> {
    includes(:balances)
    .where("inventory_entries.website_sale = ?", true)
    .references(:inventory_entries)
  }

  scope :detailed_item_for_sale, lambda {
    includes(:images).includes(:balances)
    .order("inventory_item_images.cover desc")
    .order("inventory_entries.created_at asc, inventory_entries.id asc")
  }

  scope :by_category, ->(id) {
    where(taxonomy_id: Taxonomy.friendly.find(id).self_and_descendants.pluck(:id))
  }

  scope :items_on_listing_for_website, ->{
    with_entry_for_sale.with_website_sale.limit(12).order("inventory_items.created_at desc")
  }

  scope :items_on_sale_in_category_for_website, ->(taxonomy_id) {
    with_entry_for_sale.with_website_sale.by_category(taxonomy_id)
  }

  def entry_for_website_sale
    self.entries.on_sale.default_order.for_website.first
  end

  def entry_for_point_of_sale
    self.entries.on_sale.default_order.for_point_of_sale.first
  end

  def all_entries_elligible_for_sale
    self.entries.all_entries_elligible_for_sale.to_a
  end

  def total_quantity
    entries.sum(:quantity)
  end

  def price
    Store::ItemPrice.new(self).price
  end

  def price_for_installments
    Store::ItemPrice.new(self).price_for_installments
  end

  def self.search_for(query)
    search do
      fields :name, :description, :barcode, :reference_number,
             { manufacturer: [:name], taxonomy: [:name] }
      keywords query
    end.includes(:balances).tap do |results|
      # searches into tags
      self.tagged_with(query).each { |t| results << t if t.present? }
      results
    end
  end

  # TODO test
  def translated_custom_fields(alphanumeric_name)
    @custom_fields ||= self.company.custom_fields.for_inventory_items
    @custom_fields.find { |c| c.alphanumeric_name == alphanumeric_name }.name
  end

  def remove_empty_shipping_box
    if shipping_box.present?
      self.shipping_box.destroy unless self.shipping_box.dependent_fields_present?
    end
    true
  end

  private

  def associate_with_inventory
    self.inventory = self.company.inventory
  end
end

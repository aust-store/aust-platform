class Company < ActiveRecord::Base
  has_many :admin_users
  has_many :customers, foreign_key: "store_id"
  has_many :items, class_name: "InventoryItem"
  has_many :carts
  has_many :orders, foreign_key: "store_id"
  has_many :inventory_entries, foreign_key: "store_id"
  has_many :taxonomies, foreign_key: "store_id"
  has_many :manufacturers
  has_many :pages
  has_many :banners

  has_one :address, as: :addressable
  has_one :contact, as: :contactable
  has_one :inventory
  has_one :payment_gateway, foreign_key: :store_id
  has_one :settings, class_name: "CompanySetting"

  belongs_to :theme

  accepts_nested_attributes_for :admin_users, :address, :contact

  validates :handle, uniqueness: true

  before_create :create_inventory
  before_validation :set_default_theme, on: :create
  before_validation :sanitize_domain
  after_create :create_default_pages

  def taxonomies_as_hash
    self.taxonomies.hash_tree_for_homepage
  end

  def create_inventory
    self.build_inventory
  end

  def sanitize_domain
    self.domain = Store::Company::DomainSanitizer.new(self.domain).sanitize
    true
  end

  def items_on_sale_for_website_main_page
    self.items.items_on_sale_for_website
  end

  def items_on_sale_in_category_for_website(taxonomy_id)
    self.items.items_on_sale_in_category_for_website(taxonomy_id)
  end

  def statistics
    Store::CompanyStatistics.new(self).statistics
  end

  def country
    "BR"
  end

  def currency
    "R$"
  end

  def contact_email
    self.contact and self.contact.email
  end

  def include_statistics
    @include_statistics = true
    self
  end

  def include_statistics?
    @include_statistics || false
  end

  def detailed_item(id)
    self.items.detailed_item_for_sale.friendly.find(id)
  end

  def to_param
    handle
  end

  def zipcode
    settings.zipcode if settings.present?
  end

  def has_zipcode?
    zipcode.present?
  end

  def has_domain?
    self.domain.present?
  end

  def has_payment_gateway_configured?
    self.payment_gateway.present?
  end

  def google_analytics_id
    settings.google_analytics_id if settings.present?
  end

  def sales_enabled?
    settings.sales_enabled if settings.present?
  end

  private

  def set_default_theme
    self.theme = Theme.default_theme.first if self.theme.blank?
    true
  end

  def create_default_pages
    self.pages << Page.create(title: "Quem somos", body: "Página quem somos")
  end
end

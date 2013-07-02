class Company < ActiveRecord::Base
  has_many :admin_users
  has_many :customers
  has_many :items, class_name: "InventoryItem"
  has_many :carts
  has_many :orders, foreign_key: "store_id"
  has_many :inventory_entries, foreign_key: "store_id"
  has_many :taxonomies, foreign_key: "store_id"
  has_many :manufacturers
  has_many :pages

  has_one :inventory
  has_one :payment_gateway, foreign_key: :store_id
  has_one :settings, class_name: "CompanySetting"

  belongs_to :theme

  accepts_nested_attributes_for :admin_users

  before_create :create_inventory
  before_validation :set_default_theme, on: :create
  before_validation :sanitize_domain

  def create_inventory
    self.build_inventory
  end

  def sanitize_domain
    self.domain = Store::Company::DomainSanitizer.new(self.domain).sanitize
    true
  end

  def items_on_sale_on_main_page
    self.items.items_on_sale
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

  def include_statistics
    @include_statistics = true
    self
  end

  def include_statistics?
    @include_statistics || false
  end

  def detailed_item(id)
    self.items.detailed_item_for_sale.find(id)
  end

  def to_param
    handle
  end

  def zipcode
    settings.zipcode
  end

  def has_zipcode?
    zipcode.present?
  end

  private

  def set_default_theme
    self.theme = Theme.default_theme.first if self.theme.blank?
    true
  end
end

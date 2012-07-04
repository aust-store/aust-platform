class Good < ActiveRecord::Base

  include ::Store::ModelsExtensions::Good

  belongs_to :inventory, class_name: "InventoryPersistence"
  belongs_to :user, class_name: "AdminUser", foreign_key: 'admin_user_id'
  belongs_to :company
  has_many :balances, class_name: "Good::Balance"
  has_one :last_balance, class_name: "Good::Balance", order: "updated_at desc", readonly: true
  has_many :images, class_name: "GoodImage"

  accepts_nested_attributes_for :balances
  accepts_nested_attributes_for :images

  validates :name, :admin_user_id, :company_id, presence: true

  scope :within_company, lambda { |company| where(company_id: company.id) }

  before_create :associate_with_inventory

  # TODO - move these methods to a module and load them as mixins
  searchable do
    text :name
    text :description
    integer :company_id
  end

  def associate_with_inventory
    self.inventory = self.company.inventory
  end

  def self.search_for keyword, company_id, options = {}
    search do
      fulltext keyword
      paginate page: options[:page], per_page: options[:per_page]
      with :company_id, company_id
    end.results
  end
end

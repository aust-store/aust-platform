class Good < ActiveRecord::Base
  belongs_to :inventory, class_name: "InventoryPersistence"

  has_many :balances, class_name: "Good::Balance"
  has_one :last_balance, class_name: "Good::Balance", order: "updated_at desc", readonly: true

  accepts_nested_attributes_for :balances

  validates :name, presence: true

  searchable do
    text :name, as: :name_textp
    text :description
  end
end

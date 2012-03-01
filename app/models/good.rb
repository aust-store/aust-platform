class Good < ActiveRecord::Base
  belongs_to :inventory, class_name: "InventoryPersistence"

  has_many :balances, class_name: "Good::Balance"
  validates :name, presence: true

  accepts_nested_attributes_for :balances

  searchable do
    text :name, as: :name_textp
    text :description
  end
end

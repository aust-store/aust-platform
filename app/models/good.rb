class Good < ActiveRecord::Base
  belongs_to :inventory, class_name: "InventoryPersistence"

  validates :name, presence: true
end

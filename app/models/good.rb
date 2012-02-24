class Good < ActiveRecord::Base
  belongs_to :inventory, class_name: "InventoryPersistence"
end

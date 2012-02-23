class InventoryPersistence < ActiveRecord::Base
  self.table_name = "inventories"
  belongs_to :company
end

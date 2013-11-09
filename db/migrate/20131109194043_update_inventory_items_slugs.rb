class UpdateInventoryItemsSlugs < ActiveRecord::Migration
  def up
    InventoryItem.find_each(&:save)
  end

  def down
    puts "Warning: no down() method defined"
  end
end

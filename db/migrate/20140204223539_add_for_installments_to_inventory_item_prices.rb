class AddForInstallmentsToInventoryItemPrices < ActiveRecord::Migration
  def change
    add_column :inventory_item_prices, :for_installments, :decimal, precision: 8, scale: 2
  end
end

class AddPriceForInstallmentsToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :price_for_installments, :decimal, precision: 8, scale: 2
  end
end

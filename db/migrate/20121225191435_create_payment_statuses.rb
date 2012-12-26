class CreatePaymentStatuses < ActiveRecord::Migration
  def change
    create_table :payment_statuses do |t|
      t.integer :order_id
      t.string :status
      t.text :notification_id

      t.timestamps
    end
    add_index :payment_statuses, :order_id
    add_index :payment_statuses, :status
  end
end

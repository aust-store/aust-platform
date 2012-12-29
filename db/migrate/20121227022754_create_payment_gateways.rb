class CreatePaymentGateways < ActiveRecord::Migration
  def change
    create_table :payment_gateways do |t|
      t.integer :store_id
      t.string :name
      t.string :email
      t.text :token

      t.timestamps
    end
    add_index :payment_gateways, :store_id
  end
end

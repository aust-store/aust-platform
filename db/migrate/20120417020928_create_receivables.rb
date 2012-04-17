class CreateReceivables < ActiveRecord::Migration
  def change
    create_table :receivables do |t|
      t.references :company
      t.references :admin_user
      t.references :customer
      t.decimal :value
      t.text :description
      t.datetime :due_to
      t.boolean :payed

      t.timestamps
    end
    add_index :receivables, :company_id
    add_index :receivables, :admin_user_id
    add_index :receivables, :customer_id
  end
end

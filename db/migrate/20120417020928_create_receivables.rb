class CreateReceivables < ActiveRecord::Migration
  def change
    create_table :account_receivables do |t|
      t.references :company
      t.references :admin_user
      t.references :customer
      t.decimal :value
      t.text :description
      t.date :due_to
      t.boolean :paid

      t.timestamps
    end
    add_index :account_receivables, :company_id
    add_index :account_receivables, :admin_user_id
    add_index :account_receivables, :customer_id
  end
end

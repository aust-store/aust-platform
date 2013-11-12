class RemoveCustomersTable < ActiveRecord::Migration
  def up
    drop_table :customers
  end

  def down
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :description
      t.references :company

      t.timestamps
    end
    add_index :customers, :company_id
  end
end

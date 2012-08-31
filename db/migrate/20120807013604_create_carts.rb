class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :user
      t.references :company

      t.timestamps
    end
    add_index :carts, :user_id
    add_index :carts, :company_id
  end
end

class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.references :company

      t.timestamps
    end
  end
end

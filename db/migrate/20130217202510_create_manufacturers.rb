class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :name
      t.integer :company_id

      t.timestamps
    end
    add_index :manufacturers, :company_id
  end
end

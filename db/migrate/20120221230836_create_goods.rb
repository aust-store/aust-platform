class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.references :company
      t.string :name
      t.text :description
      t.integer :reference_number
      t.decimal :cost
      t.decimal :profit_margin
      t.decimal :sale_price
      t.string :lot

      t.timestamps
    end
    add_index :goods, :company_id
  end
end

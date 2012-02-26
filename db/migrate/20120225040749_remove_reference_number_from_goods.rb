class RemoveReferenceNumberFromGoods < ActiveRecord::Migration
  def up
    remove_column :goods, :reference_number
    add_column :goods, :reference, :string

    remove_column :goods, :cost
    remove_column :goods, :profit_margin
    remove_column :goods, :sale_price
    remove_column :goods, :lot
  end

  def down
    add_column :goods, :reference_number, :integer
    remove_column :goods, :reference

    add_column :goods, :cost, :decimal
    add_column :goods, :profit_margin, :decimal
    add_column :goods, :sale_price, :decimal
    add_column :goods, :lot, :string
  end
end

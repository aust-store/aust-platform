class CustomerEmailCanBeNull < ActiveRecord::Migration
  def up
    change_column :customers, :email, :string, null: true
    remove_index :customers, :email
    add_index :customers, :email, unique: false
  end

  def down
  end
end

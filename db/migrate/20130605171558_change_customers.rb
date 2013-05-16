class ChangeCustomers < ActiveRecord::Migration
  def up
    change_column :customers, :first_name, :string, null: false
    change_column :customers, :last_name, :string, null: false
    change_column :customers, :description, :string, null: false
    change_column :customers, :company_id, :integer, null: false
  end

  def down
    change_column :customers, :first_name, :string, null: true
    change_column :customers, :last_name, :string, null: true
    change_column :customers, :description, :string, null: true
    change_column :customers, :company_id, :integer, null: true
  end
end

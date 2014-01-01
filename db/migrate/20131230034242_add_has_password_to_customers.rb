class AddHasPasswordToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :has_password, :boolean, index: true, default: true
  end
end

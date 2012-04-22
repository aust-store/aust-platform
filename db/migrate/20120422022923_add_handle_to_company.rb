class AddHandleToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :handle, :string
    add_index :companies, :handle
  end
end

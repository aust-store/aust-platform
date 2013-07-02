class AddCompanyIdToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :company_id, :integer
    add_index :themes, :company_id
  end
end

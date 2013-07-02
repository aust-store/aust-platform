class AddThemeIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :theme_id, :integer
    add_index :companies, :theme_id
  end
end

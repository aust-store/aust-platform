class AddVerticalTaxonomyMenuToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :vertical_taxonomy_menu, :boolean, default: false
  end
end

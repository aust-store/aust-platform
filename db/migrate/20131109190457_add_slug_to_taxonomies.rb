class AddSlugToTaxonomies < ActiveRecord::Migration
  def change
    add_column :taxonomies, :slug, :string
    add_index :taxonomies, :slug
  end
end

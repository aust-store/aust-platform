class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table :taxonomies do |t|
      t.text :name
      t.integer :parent_id
      t.integer :store_id

      t.timestamps
    end
    add_index :taxonomies, :parent_id
    add_index :taxonomies, :store_id
  end
end

class CustomFieldsTaxonomies < ActiveRecord::Migration
  def change
    create_table :custom_fields_taxonomies, id: false do |t|
      t.integer :custom_field_id, index: true
      t.integer :taxonomy_id,     index: true
    end
  end
end

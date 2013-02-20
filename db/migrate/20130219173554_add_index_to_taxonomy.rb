class AddIndexToTaxonomy < ActiveRecord::Migration
  def up
    execute "create index taxonomies_name on taxonomies using gin(to_tsvector('english', name))"
  end

  def down
    execute "drop index taxonomies_name"
  end
end

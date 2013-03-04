class AddFtsIndexToManufacturers < ActiveRecord::Migration
  def up
    execute "create index manufacturers_name on manufacturers using gin(to_tsvector('english', name))"
  end

  def down
    execute "drop index manufacturers_name"
  end
end

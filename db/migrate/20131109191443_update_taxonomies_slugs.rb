class UpdateTaxonomiesSlugs < ActiveRecord::Migration
  def up
    Taxonomy.find_each(&:save)
  end

  def down
    puts "Warning: no down() method defined"
  end
end

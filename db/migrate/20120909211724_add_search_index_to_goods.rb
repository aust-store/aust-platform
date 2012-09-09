class AddSearchIndexToGoods < ActiveRecord::Migration
  def up
    execute "create index good_name on goods using gin(to_tsvector('english', name))"
    execute "create index good_description on goods using gin(to_tsvector('english', description))"
  end

  def down
    execute "drop index good_name"
    execute "drop index good_description"
  end
end

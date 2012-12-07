class CreateAdminSettings < ActiveRecord::Migration
  def change
    create_table :company_settings do |t|
      t.integer :company_id
      t.hstore :settings

      t.timestamps
    end

    add_index :company_settings, :company_id
    execute "CREATE INDEX company_settings_gist_settings ON company_settings USING GIST(settings);"
  end
end

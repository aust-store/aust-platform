class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.text :description
      t.text :path
      t.boolean :public, default: true

      t.timestamps
    end
  end
end

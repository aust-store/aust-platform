class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.references :company, index: true
      t.string :related_type
      t.string :name
      t.string :alphanumeric_name

      t.timestamps
    end
    add_index :custom_fields, :related_type
  end
end

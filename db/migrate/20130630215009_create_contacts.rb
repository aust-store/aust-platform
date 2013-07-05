class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :phone_1
      t.string :phone_2
      t.string :email
      t.integer :contactable_id
      t.string :contactable_type

      t.timestamps
    end
    add_index :contacts, :contactable_id
    add_index :contacts, :contactable_type
  end
end

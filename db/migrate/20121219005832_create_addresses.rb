class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :addressable_id
      t.string :addressable_type
      t.text :address_1
      t.text :address_2
      t.text :city
      t.text :zipcode
      t.string :state
      t.string :country
      t.boolean :default

      t.timestamps
    end

    add_index :addresses, [:addressable_id, :addressable_type]
    add_index :addresses, :default
  end
end

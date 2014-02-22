class CreatePeopleRoles < ActiveRecord::Migration
  def change
    create_table :people_roles do |t|
      t.references :person, index: true
      t.references :role, index: true

      t.timestamp
    end
  end
end

class CreateRoles < ActiveRecord::Migration
  class Role < ActiveRecord::Base; end

  def up
    create_table :roles do |t|
      t.string :name
    end
    add_index :roles, :name

    Role.create(name: "customer")
    Role.create(name: "supplier")
  end

  def down
    drop_table :roles
  end
end

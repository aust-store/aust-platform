class AddProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :text
    add_column :users, :last_name, :text
    add_column :users, :social_security_number, :string
    add_column :users, :nationality, :string
    add_column :users, :receive_newsletter, :boolean

    add_index :users, :receive_newsletter
  end
end

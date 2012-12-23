class AddPhoneFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_number, :string
    add_column :users, :home_number, :string
    add_column :users, :work_number, :string
  end
end

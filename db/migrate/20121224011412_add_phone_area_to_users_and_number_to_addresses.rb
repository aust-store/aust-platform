class AddPhoneAreaToUsersAndNumberToAddresses < ActiveRecord::Migration
  def change
    add_column :users, :home_area_number, :string
    add_column :users, :work_area_number, :string
    add_column :users, :mobile_area_number, :string
    add_column :addresses, :number, :string
  end
end

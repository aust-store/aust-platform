class MigratePolymorphicRecordsToCustomers < ActiveRecord::Migration
  def up
    Address.where(addressable_type: "User").find_each do |address|
      address.update_attribute(:addressable_type, "Customer")
    end

    Contact.where(contactable_type: "User").find_each do |contact|
      contact.update_attribute(:contactable_type, "Customer")
    end
  end

  def down

  end
end

class AddEnabledToCustomers < ActiveRecord::Migration
  class Customer < ActiveRecord::Base; end

  def up
    add_column :customers, :enabled, :bool, default: true
    add_index :customers, :enabled

    Customer.find_each { |customer| customer.update_attributes(enabled: true) }
  end

  def down
    remove_column :customers, :enabled
  end
end

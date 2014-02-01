class UpdateCustomersToHaveWebsiteEnvironment < ActiveRecord::Migration
  class Customer < ActiveRecord::Base; end

  def up
    Customer.find_each do |customer|
      customer.update_attributes(environment: "website")
    end
  end

  def down
    Customer.find_each do |customer|
      customer.update_attribute(:environment, "")
    end
  end
end

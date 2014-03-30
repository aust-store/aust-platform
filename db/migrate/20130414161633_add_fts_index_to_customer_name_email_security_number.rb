class AddFtsIndexToCustomerNameEmailSecurityNumber < ActiveRecord::Migration
  def up
    execute "create index customer_first_name on users using gin(to_tsvector('english', first_name))"
    execute "create index customer_last_name on users using gin(to_tsvector('english', first_name))"
    execute "create index customer_social_security_number on users using gin(to_tsvector('english', social_security_number))"
    execute "create index customer_email on users using gin(to_tsvector('english', email))"
  end

  def down
    execute "drop index customer_first_name"
    execute "drop index customer_last_name"
    execute "drop index customer_social_security_number"
    execute "drop index customer_email"
  end
end

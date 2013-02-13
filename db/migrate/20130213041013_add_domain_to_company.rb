class AddDomainToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :domain, :text
    add_index :companies, :domain
  end
end

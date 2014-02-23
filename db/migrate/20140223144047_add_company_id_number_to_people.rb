class AddCompanyIdNumberToPeople < ActiveRecord::Migration
  def change
    add_column :people, :company_id_number, :string
  end
end

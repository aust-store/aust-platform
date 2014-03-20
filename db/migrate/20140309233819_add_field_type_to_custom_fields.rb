class AddFieldTypeToCustomFields < ActiveRecord::Migration
  class CustomField < ActiveRecord::Base; end

  def up
    add_column :custom_fields, :field_type, :string
    add_column :custom_fields, :options, :hstore
    add_index  :custom_fields, :options, using: :gin

    CustomField.update_all(field_type: "string")
  end

  def down
    remove_column :custom_fields, :field_type
    remove_column :custom_fields, :options
  end
end

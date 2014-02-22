class PersonRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :person

  self.table_name = "people_roles"
end

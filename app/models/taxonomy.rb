class Taxonomy < ActiveRecord::Base
  acts_as_tree order: 'id'

  belongs_to :store, foreign_key: 'store_id', class_name: "Company"
  attr_accessible :name, :parent_id, :store_id
end

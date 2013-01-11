class TaxonomySerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_id, :created_at
end

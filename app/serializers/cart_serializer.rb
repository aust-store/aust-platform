class CartSerializer < ActiveModel::Serializer
  attributes :id, :total
  has_many :items
end

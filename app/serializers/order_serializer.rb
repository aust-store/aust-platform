class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total
  has_many :items
end

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :created_at, :environment
  has_many :items

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end

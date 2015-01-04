class CartSerializer < ActiveModel::Serializer
  attributes :id, :total

  has_many :items
  belongs_to :customer

  def id
    object.uuid
  end

  def filter(keys)
    if object.customer.blank?
      keys.delete(:customer)
    end
    keys
  end
end

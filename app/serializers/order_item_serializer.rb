class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity,
    :price, :price_for_installments

  belongs_to :order
  belongs_to :inventory_item
  belongs_to :inventory_entry

  def id
    object.uuid
  end
end

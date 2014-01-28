class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :created_at, :environment, :payment_type

  has_many :items, key: :order_item_ids, root: :order_items, embed_key: :uuid, embed_in_root: true
  has_one :customer, key: :customer_id, root: :customer, embed_key: :uuid, embed_in_root: true

  def id
    object.uuid
  end

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def filter(keys)
    keys.delete(:customer) if object.customer.blank?
    keys.delete(:items) unless @options[:include_items] == true
    keys
  end
end

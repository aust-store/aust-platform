class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :created_at, :environment

  has_many :items, key: :order_item_ids, root: :order_items, embed_in_root: true

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def filter(keys)
    keys.delete(:items) unless @options[:include_items] == true
    keys
  end
end

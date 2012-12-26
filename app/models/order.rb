class Order < ActiveRecord::Base
  attr_accessible :cart_id, :store_id, :user_id

  belongs_to :user
  belongs_to :store, class_name: "Company"
  has_many :items, class_name: "OrderItem"
  has_one :shipping_details, class_name: "OrderShipping"
  has_one :shipping_address, as: :addressable, class_name: "Address"
end

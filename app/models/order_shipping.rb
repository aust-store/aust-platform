class OrderShipping < ActiveRecord::Base
  belongs_to :cart
  belongs_to :order
  attr_accessible :delivery_days, :delivery_type, :price, :service_type, :cart

  def self.create_for_cart(options = {})
    destroy_all(cart_id: options[:cart].id)
    create(options)
  end
end

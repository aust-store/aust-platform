class OrderShipping < ActiveRecord::Base
  belongs_to :cart
  belongs_to :order
  attr_accessible :delivery_days, :delivery_type, :price, :service_type, :cart,
                  :zipcode,
                  :package_width, :package_height, :package_weight, :package_length

  def create_for_cart(shipping)
    options = {
      price:          shipping.total,
      delivery_days:  shipping.days,
      delivery_type:  shipping.company_name,
      service_type:   shipping.type,
      zipcode:        shipping.destination_zipcode,
      package_width:  shipping.package_width,
      package_length: shipping.package_length,
      package_height: shipping.package_height,
      package_weight: shipping.package_weight,
    }
    self.update_attributes(options)
    self
  end
end

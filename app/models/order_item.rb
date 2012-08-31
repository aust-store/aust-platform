class OrderItem < ActiveRecord::Base
  belongs_to :inventory_item, class_name: "Good"
  belongs_to :inventory_entry
end

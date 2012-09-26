class OrderItem < ActiveRecord::Base
  belongs_to :inventory_item, class_name: "Good"
  belongs_to :inventory_entry

  def name
    inventory_item.name
  end

  def description
    inventory_item.description
  end
end

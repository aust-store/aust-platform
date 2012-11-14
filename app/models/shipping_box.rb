class ShippingBox < ActiveRecord::Base
  belongs_to :inventory_items, dependent: :destroy

  attr_accessible :height, :inventory_items, :length, :weight, :width
end

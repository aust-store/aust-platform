class InventoryItemImage < ActiveRecord::Base
  belongs_to :inventory_item

  mount_uploader :image, ImageGoodUploader

  attr_accessible :cover, :image
end

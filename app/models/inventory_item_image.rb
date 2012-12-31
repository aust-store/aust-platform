class InventoryItemImage < ActiveRecord::Base
  belongs_to :inventory_item

  mount_uploader :image, ImageGoodUploader

  attr_accessible :cover, :image

  before_save :set_as_cover_if_first

  def set_as_cover_if_first
    self.cover = true if self.inventory_item.images.size == 0
  end
end

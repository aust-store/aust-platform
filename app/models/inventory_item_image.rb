class InventoryItemImage < ActiveRecord::Base
  belongs_to :inventory_item

  mount_uploader :image, ImageItemUploader

  attr_accessible :cover, :image

  before_save :set_as_cover_if_first

  scope :cover, ->{ where(cover: true) }
  scope :default_order, ->{ order("cover desc, id desc") }

  def set_as_cover_if_first
    self.cover = true if self.inventory_item.images.size == 0
  end

  def self.has_cover?
    cover.count > 0
  end
end

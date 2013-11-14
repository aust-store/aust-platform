class InventoryItemImage < ActiveRecord::Base
  belongs_to :inventory_item

  mount_uploader :image, ImageItemUploader

  attr_accessible :cover, :image

  before_save :set_as_cover_if_first

  scope :cover, ->{ where(cover: true) }
  scope :non_cover, ->{ where(cover: false) }
  scope :default_order, ->{ order("cover desc, id desc") }

  def set_as_cover_if_first
    if item_images.blank?
      self.cover = true
    else
      item_images.update_all(cover: false) if self.cover?
    end
  end

  def self.has_cover?
    cover.count > 0
  end

  private

  def item_images
    self.inventory_item.try(:images)
  end
end

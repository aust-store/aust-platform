class GoodImage < ActiveRecord::Base
  belongs_to :good

  mount_uploader :image, ImageGoodUploader

  attr_accessible :cover, :image
end

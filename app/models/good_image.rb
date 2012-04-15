class GoodImage < ActiveRecord::Base
  belongs_to :good
  mount_uploader :image, ImageGoodUploader
end

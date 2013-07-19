class Banner < ActiveRecord::Base
  belongs_to :company
  mount_uploader :image, ImageBannerUploader

  validates :image, :position, presence: true
  validate :url_validate_format

  scope :all_pages_right, ->{ where(position: "all_pages_right") }

  def image_url
    image.url
  end

  def url_validate_format
    return true if url.blank?
    errors.add(:url , :invalid) unless CommonTools::Url.new(url).valid?
  end
end

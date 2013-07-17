class Banner < ActiveRecord::Base
  belongs_to :company
  mount_uploader :image, ImageBannerUploader

  validates :title, :image, :position, presence: true
  validate :url_validate_format

  def image_url
    image.url
  end

  def url_validate_format
    return true if url.blank?

    unless UrlValidator::Url.validate(url)
      errors.add(:url , :invalid)
    end
  end

end

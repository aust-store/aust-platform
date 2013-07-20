class Banner < ActiveRecord::Base
  POSITIONS = [
    "all_pages_right",           # appear in the right lateral of all pages
    "main_page_central_rotative" # rotating, big banners in the center of main page
  ]

  belongs_to :company
  mount_uploader :image, ImageBannerUploader

  validates :image, :position, presence: true
  validates :position, inclusion: { in: POSITIONS }
  validate :url_validate_format
  validate :position_max_slots

  scope :all_pages_right, ->{ where(position: "all_pages_right") }
  scope :main_page_central_rotative, ->{ where(position: "main_page_central_rotative") }

  def image_url
    image.url
  end

  private

  def url_validate_format
    return true if url.blank?
    errors.add(:url , :invalid) unless CommonTools::Url.new(url).valid?
  end

  def position_max_slots
    return true if self.company_id.blank?
    eligible = Store::Policy::Company::Banners.new(self.company).eligible?(self.position)
    errors.add(:position , :quantity) unless eligible
  end
end

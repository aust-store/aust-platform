module ImagesHelper
  def has_images good
    return true unless good.good_images.blank?
    return false if good.good_images.first.blank?
    return false if good.good_images.first.id

    return true

  end
end

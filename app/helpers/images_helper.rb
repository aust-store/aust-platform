module ImagesHelper
  def has_images good
    return true unless good.images.blank?
    return false if good.images.first.blank?
    return false if good.images.first.id

    return true

  end
end

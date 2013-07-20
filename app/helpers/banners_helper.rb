module BannersHelper
  def banners(position, options = {})
    return if @banners[position].blank?
    result = ""
    width = options[:width]

    @banners[position].each do |banner|
      result << if banner.url.present?
        link_to(image_tag(banner.image.url, title: banner.title, width: width), banner.url)
      else
        image_tag(banner.image.url, title: banner.title, width: width)
      end
    end
    raw result
  end
end

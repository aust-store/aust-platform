module BannersHelper
  def banners(position, options = {})
    return unless banners?(position)
    result = ""
    width = options[:width]

    @banners[position].each do |banner|
      result << content_tag(:div, class: "main_page_central_transition_banner") do
        if banner.url.present?
          link_to(image_tag(banner.image.url, title: banner.title, width: width), banner.url)
        else
          image_tag(banner.image.url, title: banner.title, width: width)
        end
      end
    end
    raw result
  end

  def banners_amount(position)
    Array(@banners[position]).size
  end

  def banners?(position)
    @banners[position].present?
  end
end

module Admin::BannersHelper
  def new_banner_button(company)
    unless company.elegible_for_lateral_banners?
       "<p style='color:red'>#{t('admin.banners.message.full')}</p>".html_safe
    else
      small_button new_admin_banner_path, text: t('admin.banners.index.new_banner'),
      image: 'admin/icons/plus_16.png', class: "round_icon.banners"
    end
  end
end

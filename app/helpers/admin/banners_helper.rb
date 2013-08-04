module Admin::BannersHelper
  def new_banner_button
    unless Store::Policy::Company::Banners.new(@company).eligible?
      "<p style='color:red'>#{t('admin.banners.message.full')}</p>".html_safe
    else
      small_button t('admin.banners.index.new_banner'),
        new_admin_banner_path,
        image: 'admin/icons/plus_16.png',
        class: "banners"
    end
  end

  def banner_position_select_options
    options = []
    Banner::POSITIONS.each do |position|
      message = t("activerecord.values.banner.position.#{position}")
      unless Store::Policy::Company::Banners.new(@company).eligible?(position)
        message << " (#{t("admin.banners.form.no_more_slots_available")})"
      end
      options << [ message, position ]
    end
    options
  end
end

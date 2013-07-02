# encoding: utf-8
module SuperAdmin::NavigationHelper
  def back(path, link_text = I18n.t("back"))
    link_to "<span class=\"special_arrow\">◀</span> #{link_text}".html_safe, path
  end
end

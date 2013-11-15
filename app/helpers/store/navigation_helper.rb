# encoding: utf-8
module Store::NavigationHelper
  def current_page_class(path_id)
    "current" if url_for == path_id || controller_name == path_id
  end

  def controller_name
    params[:controller]
  end
end

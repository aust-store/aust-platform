# encoding: utf-8
module Store::NavigationHelper
  def current_page_class(path_id)
    "current" if url_for == path_id || params[:controller] == path_id
  end
end

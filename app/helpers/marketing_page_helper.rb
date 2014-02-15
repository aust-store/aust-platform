module MarketingPageHelper

  # Navigation
  def current_class(url)
    return "current" if url_for == url
  end
end

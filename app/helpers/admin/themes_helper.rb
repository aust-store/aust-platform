module Admin::ThemesHelper
  def current_theme(theme)
    @current_company.theme == theme
  end
end

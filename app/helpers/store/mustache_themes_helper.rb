module Store::MustacheThemesHelper
  def render_theme_layout(action_view_context)
    layout = View::StoreTheme::Layout.new(@store_view, action_view_context)
    render layout.layout_to_be_rendered
  end
end

class Admin::ThemeEditorController < Admin::ApplicationController
  layout "theme_editor"

  def show
    @theme = Theme.accessible_for_company(current_company).find(params[:id])
    render text: "", layout: true
  end
end

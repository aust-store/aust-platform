class Admin::ThemeEditorController < ApplicationController
  layout "theme_editor"

  def show
    # FIXME
    @theme = Theme.find(params[:id])
    render text: "", layout: true
  end
end

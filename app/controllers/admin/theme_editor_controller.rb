class Admin::ThemeEditorController < ApplicationController
  layout "theme_editor"

  def show
    render text: "", layout: true
  end
end

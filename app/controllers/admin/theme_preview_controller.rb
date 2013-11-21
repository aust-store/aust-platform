# encoding: utf-8
class Admin::ThemePreviewController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  def show
    # FIXME we can't allow any theme to be previewed
    session[:preview_theme_id] = Theme.find(params[:id]).id
    redirect_to root_url and return
  end

  def destroy
    session[:preview_theme_id] = nil
    redirect_to root_url and return
  end
end

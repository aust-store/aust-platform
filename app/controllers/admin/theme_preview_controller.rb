# encoding: utf-8
class Admin::ThemePreviewController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  def show
    session[:preview_theme_id] = Theme.accessible_for_company(current_company).find(params[:id]).id
    redirect_to root_url and return
  end

  def destroy
    session[:preview_theme_id] = nil
    redirect_to root_url and return
  end
end

# encoding: utf-8
class Admin::Api::ThemeFilesController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @theme = find_theme(params[:theme_id])
    theme_files = @theme.files.all.map { |file| add_hyperlink(file.to_json) }
    render json: { theme_files: theme_files }
  end

  def update
    @theme = find_theme(params[:theme_file][:theme_id])
    theme_file = @theme.files.find(params[:theme_file][:filename])
    theme_file.update_attributes(body: params[:theme_file][:body])
    theme_file = add_hyperlink(theme_file.to_json)
    render json: { theme_file: add_hyperlink(theme_file) }
  end

  private

  def find_theme(theme_id)
    @theme ||= Theme.accessible_for_company(current_company).find(theme_id)
  end

  def add_hyperlink(file)
    file.merge({
      preview_url: admin_theme_preview_url(@theme, filename: file[:filename]),
    })
  end
end

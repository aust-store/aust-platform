# encoding: utf-8
class Admin::Api::ApplicationController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  private

  def search(resource)
    resource = resource.search_for(params[:search]) if params[:search].present?
    resource
  end

  def limit(resource)
    resource = resource.limit(3)
    if params[:limit].to_i.present? && params[:limit].to_i > 0
      resource = resource.limit(params[:limit].to_i)
    end
    resource
  end
end

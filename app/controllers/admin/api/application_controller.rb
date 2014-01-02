# encoding: utf-8
class Admin::Api::ApplicationController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  private

  def replace_uuid_with_id(resource_params, scope, id_field)
    if resource_params[id_field].present?
      resource_id = scope.find_by_uuid(resource_params[id_field]).id
      resource_params.merge!(id_field => resource_id)
    end
    resource_params
  end

  def search(resource)
    resource = resource.search_for(search_param) if search_param.present?
    resource
  end

  def search_param
    @search_param ||= params[:search].strip
  end

  def limit(resource)
    resource = resource.limit(10)
    if params[:limit].to_i.present? && params[:limit].to_i > 0
      resource = resource.limit(params[:limit].to_i)
    end
    resource
  end
end

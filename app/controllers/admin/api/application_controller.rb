# encoding: utf-8
class Admin::Api::ApplicationController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :admin_dashboard_redirections

  before_filter :manual_exit

  private

  def manual_exit
    #exit
  end

  # Takes a passed in UUID (via params) and replaces it with the appropriate
  # ID defined in the database. e.g.
  #
  # { cart: {
  #     items: [{
  #       "id": "12341234-1234-1234-1234123412"
  #     }
  #   }
  # }
  #
  # This method will convert the :items hash's id into the proper DB ID.
  #
  # @param resource_params - the passed in param, usually strong_parameter
  # @param scope - ActiveRecord relation where `#find` will be called
  # @id_field - the field name that needs to be replaced
  def replace_uuid_with_id(resource_params, scope, id_field)
    if resource_params[id_field].present?
      resource_id = scope.find_by_uuid(resource_params[id_field]).id
      resource_params.merge!(id_field => resource_id)
    end
    resource_params
  end

  def replace_id_with_uuid(resource_params, id_field = :id, uuid_field = :uuid)
    if resource_params[id_field].present?
      resource_params[uuid_field] = resource_params[id_field]
      resource_params.delete(id_field)
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

  # TODO - using Kaminari, which overwrites limit(), this can be removed
  # once all endpoint are returning paginated results.
  def limit(resource)
    resource = resource.limit(10)
    if params[:limit].to_i.present? && params[:limit].to_i > 0
      resource = resource.limit(params[:limit].to_i)
    end
    resource
  end

  #
  # Pagination
  def paginate_resource
    @resources = @resources.page(current_page).per(items_per_page)
  end

  def items_per_page
    100
  end

  def current_page
    (params[:page] && params[:page].to_i) || 1
  end

  def total_pages
    @resources.total_pages
  end

  #
  # Meta
  def meta
    { page: current_page, total_pages: total_pages }
  end
end

# encoding: utf-8
class Admin::Api::CustomersController < Admin::Api::ApplicationController
  def index
    resource = current_company.customers
    resource = search(resource)
    resource = limit(resource)

    render json: resource
  end

  def update
    resource = current_company.customers.find(params[:id])
    resource.update_attributes(params[:customer])
    render json: resource
  end
end

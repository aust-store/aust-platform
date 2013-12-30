# encoding: utf-8
class Admin::Api::CustomersController < Admin::Api::ApplicationController
  def index
    resource = current_company.customers
    resource = search(resource)
    resource = limit(resource)

    render json: resource
  end

  def create
    resource = current_company.customers.create(customer_params)
    render json: resource
  end

  def update
    resource = current_company.customers.find(params[:id])
    resource.update_attributes(params[:customer])
    render json: resource
  end

  private

  def customer_params
    params
      .require(:customer)
      .permit(:first_name, :last_name, :email, :social_security_number)
      .merge(environment: "point_of_sale")
  end
end

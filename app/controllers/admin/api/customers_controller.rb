# encoding: utf-8
class Admin::Api::CustomersController < Admin::Api::ApplicationController
  def index
    resource = current_company.customers
    resource = search(resource)
    resource = limit(resource)

    render json: resource
  end

  def create
    resource = current_company.customers.new(customer_params)
    if resource.save
      render json: resource
    else
      render json: {errors: resource.errors.first_messages}, status: 422
    end
  end

  def update
    resource = current_company.customers.find_by_uuid(params[:id])
    if resource.update_attributes(customer_params)
      render json: resource
    else
      render json: {errors: resource.errors.first_messages}, status: 422
    end
  end

  private

  def customer_params
    params
      .require(:customer)
      .permit(:first_name, :last_name, :email, :social_security_number)
      .merge(environment: "point_of_sale")
  end
end
